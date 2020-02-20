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

pixelKitMetalLibURL = getURL("~/Code/Frameworks/Production/PixelKit/Resources/Metal Libs/PixelKitShaders-macOS.metallib")

var brigtnessVal: CGFloat?
var gammaVal: CGFloat?
var hueVal: CGFloat?
var saturationVal: CGFloat?

enum Arg: CaseIterable {
    case brigtness
    case gamma
    case hue
    case saturation
    case metalLib
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
        case .brigtness: return "b"
        case .gamma: return "g"
        case .hue: return "h"
        case .saturation: return "s"
        case .metalLib: return "m"
        }
    }
    var longFlag: String {
        switch self {
        case .brigtness: return "brightness"
        case .gamma: return "gamma"
        case .hue: return "hue"
        case .saturation: return "saturation"
        case .metalLib: return "metallib"
        }
    }
    var type: String {
        switch self {
        case .brigtness, .gamma, .hue, .saturation: return "float"
        case .metalLib: return "path"
        }
    }
    var info: String {
        "[-\(shortFlag) | --\(longFlag) <\(type)>]"
    }
    func action(_ argStr: String) {
        switch self {
        case .metalLib:
            pixelKitMetalLibURL = getURL(argStr)
        case .brigtness, .gamma, .hue, .saturation:
            guard let val: Float = Float(argStr) else {
                print("val \(argStr) for arg \(longFlag) needs to be a \(type)")
                exit(EXIT_FAILURE)
            }
            let cgVal: CGFloat = CGFloat(val)
            switch self {
            case .brigtness:
                brigtnessVal = cgVal
            case .gamma:
                gammaVal = cgVal
            case .hue:
                hueVal = cgVal
            case .saturation:
                saturationVal = cgVal
            default:
                break
            }
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

frameLoopRenderThread = .background
PixelKit.main.render.engine.renderMode = .manual

guard let inImg: NSImage = NSImage(contentsOf: inURL) else {
    print("input image corrupt")
    print(outURL.path)
    exit(EXIT_FAILURE)
}

// MARK: - PIXs

let img = ImagePIX()
img.image = inImg

let lvl = LevelsPIX()
lvl.input = img
if let val: CGFloat = brigtnessVal {
    lvl.brightness = LiveFloat(val)
}
if let val: CGFloat = gammaVal {
    lvl.gamma = LiveFloat(val)
}

let hst = HueSaturationPIX()
hst.input = lvl
if let val: CGFloat = hueVal {
    hst.hue = LiveFloat(val)
}
if let val: CGFloat = saturationVal {
    hst.saturation = LiveFloat(val)
}

let fnl: PIX = hst

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
