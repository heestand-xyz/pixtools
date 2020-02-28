import AppKit
import LiveValues
import RenderKit
import PixelKit

let args = CommandLine.arguments
let fm = FileManager.default

let callURL: URL = URL(fileURLWithPath: args[0])

func getURL(_ path: String) -> URL {
    if path.starts(with: "/") {
        return URL(fileURLWithPath: path)
    }
    if path.starts(with: "~/") {
        let docsURL: URL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docsURL.deletingLastPathComponent().appendingPathComponent(path.replacingOccurrences(of: "~/", with: ""))
    }
    return callURL.appendingPathComponent(path)
}

var didSetup: Bool = false
var didSetLib: Bool = false

func setup() {
    guard didSetLib else { return }
    guard !didSetup else { return }
    frameLoopRenderThread = .background
    PixelKit.main.render.engine.renderMode = .manual
    #if DEBUG
    PixelKit.main.logDebug()
    #endif
    didSetup = true
}

func setLib(url: URL) {
    guard !didSetLib else { return }
    guard fm.fileExists(atPath: url.path) else { return }
    pixelKitMetalLibURL = url
    didSetLib = true
    setup()
}
setLib(url: getURL("~/Code/Frameworks/Production/PixelKit/Resources/Metal Libs/PixelKitShaders-macOS.metallib"))

var finalResolution: Resolution?
struct Effect {
    let name: String
    var auto: AutoPIXSingleEffect
    var pix: PIXSingleEffect
    init(_ auto: AutoPIXSingleEffect) {
        name = auto.rawValue.replacingOccurrences(of: "pix", with: "")
        self.auto = auto
        pix = auto.pixType.init()
    }
}
var effects: [Effect] = []

enum Arg: CaseIterable {
    case metalLib
    case resolution
    case effect
    case property
    init?(shortFlag: String) {
        guard let arg: Arg = Arg.allCases.first(where: {
            $0.shortFlag == shortFlag || "-\($0.shortFlag)" == shortFlag
        }) else { return nil }
        self = arg
    }
    init?(longFlag: String) {
        guard let arg: Arg = Arg.allCases.first(where: {
            $0.longFlag == longFlag || "--\($0.longFlag)" == longFlag
        }) else { return nil }
        self = arg
    }
    var shortFlag: String {
        switch self {
        case .metalLib: return "m"
        case .resolution: return "r"
        case .effect: return "e"
        case .property: return "p"
        }
    }
    var longFlag: String {
        switch self {
        case .metalLib: return "metallib"
        case .resolution: return "resolution"
        case .effect: return "effect"
        case .property: return "property"
        }
    }
    var type: String {
        switch self {
        case .metalLib: return "path"
        case .resolution: return "1920x1080"
        case .effect: return "name"
        case .property: return "name:float"
        }
    }
    var info: String {
        "[-\(shortFlag) | --\(longFlag) <\(type)>]"
    }
    func action(_ argStr: String) {
        switch self {
        case .metalLib:
            let url: URL = getURL(argStr)
            setLib(url: url)
            guard didSetLib else {
                print("bad metal lib path")
                print(url.path)
                exit(EXIT_FAILURE)
            }
        case .resolution:
            let argParts: [String] = argStr.split(separator: "x").map({ "\($0)" })
            guard argParts.count == 2 else {
                print("resolution sign: <1920x1080>")
                exit(EXIT_FAILURE)
            }
            let wStr: String = argParts[0]
            guard let w: Int = Int(wStr) else {
                print("bad width value: \"\(wStr)\"")
                print("the value needs to be a int")
                exit(EXIT_FAILURE)
            }
            let hStr: String = argParts[1]
            guard let h: Int = Int(hStr) else {
                print("bad width height: \"\(hStr)\"")
                print("the value needs to be a int")
                exit(EXIT_FAILURE)
            }
            finalResolution = .custom(w: w, h: h)
        case .effect:
            guard let auto: AutoPIXSingleEffect = AutoPIXSingleEffect(rawValue: "\(argStr)pix") else {
                print("no effect \"\(argStr)\"")
                for auto in AutoPIXSingleEffect.allCases {
                    print(auto.rawValue.replacingOccurrences(of: "pix", with: ""))
                }
                exit(EXIT_FAILURE)
            }
            effects.append(Effect(auto))
        case .property:
            guard let effect: Effect = effects.last else {
                print("property requires effect")
                exit(EXIT_FAILURE)
            }
            let argParts: [String] = argStr.split(separator: ":").map({ "\($0)" })
            guard argParts.count == 2 else {
                print("property sign: <name:float>")
                exit(EXIT_FAILURE)
            }
            let name: String = argParts[0]
            let properties = effect.auto.allAutoLivePropertiesAsFloats(for: effect.pix)
            guard let property = properties.first(where: { $0.name == name }) else {
                print("no property \"\(name)\" for effect \"\(effect.name)\"")
                for property in properties {
                    print(property.name)
                }
                exit(EXIT_FAILURE)
            }
            let valueStr: String = argParts[1]
            guard let value: Float = Float(valueStr) else {
                print("bad property value: \"\(valueStr)\"")
                print("the value needs to be a float")
                exit(EXIT_FAILURE)
            }
            property.value = LiveFloat(value)
        }
    }
}

let preArgCount: Int = 3
let flagArgCount: Int = args.filter({ $0.starts(with: "-") || $0.starts(with: "--") }).count
guard args.count - flagArgCount * 2 == preArgCount else {
    print("pixtools <input> <output>\n\(Arg.allCases.map({ $0.info }).joined(separator: "\n"))")
    exit(EXIT_FAILURE)
}
let inURL: URL = getURL(args[1])
var isDir: ObjCBool = false
let exists: Bool = fm.fileExists(atPath: inURL.path, isDirectory: &isDir)
guard exists && !isDir.boolValue && ["png", "jpg", "tiff"].contains(inURL.pathExtension.lowercased()) else {
    print("input needs to be an image file")
    print(inURL.path)
    exit(EXIT_FAILURE)
}
let outURL: URL = getURL(args[2])
guard outURL.pathExtension == "png" else {
    print("output needs to be a png file path")
    print(outURL.path)
    exit(EXIT_FAILURE)
}

var atArg: Arg?
for (i, argStr) in args.enumerated() {
    guard i >= preArgCount else { continue }
    if let arg: Arg = atArg {
        arg.action(argStr)
        atArg = nil
    } else {
        if argStr.starts(with: "--") {
            guard let arg: Arg = Arg(longFlag: argStr) else {
                print("flag \(argStr) is not valid")
                exit(EXIT_FAILURE)
            }
            atArg = arg
        } else if argStr.starts(with: "-") {
            guard let arg: Arg = Arg(shortFlag: argStr) else {
                print("flag \(argStr) is not valid")
                exit(EXIT_FAILURE)
            }
            atArg = arg
        }
    }
}

// MARK: - PIXs

var fnl: PIX & NODEOut

let img = ImagePIX()
guard let inImg: NSImage = NSImage(contentsOf: inURL) else {
    print("input image corrupt")
    print(outURL.path)
    exit(EXIT_FAILURE)
}
img.image = inImg
fnl = img

if let resolution: Resolution = finalResolution {
    let res = ResolutionPIX(at: resolution)
    res.placement = .aspectFill
    res.input = fnl
    fnl = res
}

for effect in effects {
    effect.pix.input = fnl
    fnl = effect.pix
}

guard didSetup else { exit(EXIT_FAILURE) }

// MARK: - Render

print("will render")
var outImg: NSImage!
let group = DispatchGroup()
group.enter()
try! PixelKit.main.render.engine.manuallyRender {
    guard let img: NSImage = fnl.renderedImage else {
        print("render failed")
        exit(EXIT_FAILURE)
    }
    outImg = img
    print("did render")
    group.leave()
}
group.wait()

let outData: Data = NSBitmapImageRep(data: outImg.tiffRepresentation!)!.representation(using: .png, properties: [:])!
try outData.write(to: outURL)

print("done!")
