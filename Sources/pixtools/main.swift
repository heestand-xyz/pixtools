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

guard args.count - args.filter({ $0.starts(with: "--") }).count * 2 == 2 else {
    print("pixtools <output> [--metalLib]")
    exit(EXIT_FAILURE)
}
let outURL: URL = getURL(args[1])
var isDir: ObjCBool = false
let exists: Bool = fm.fileExists(atPath: outURL.path, isDirectory: &isDir)
guard exists && isDir.boolValue else {
    print("output is not a valid folder")
    print(outURL.path)
    exit(EXIT_FAILURE)
}

enum Arg: String {
    case metalLib = "--metalLib"
    func action(_ argStr: String) {
        switch self {
        case .metalLib:
            print("argStr:", argStr)
            pixelKitMetalLibURL = getURL(argStr)
        }
    }
}
var atArg: Arg?
for (i, argStr) in args.enumerated() {
    guard i > 0 else { continue }
    if let arg: Arg = atArg {
        arg.action(argStr)
        atArg = nil
    } else {
        guard argStr.starts(with: "--") else { continue }
        if let arg: Arg = Arg(rawValue: argStr) {
            atArg = arg
        }
    }
}

frameLoopRenderThread = .background
PixelKit.main.render.engine.renderMode = .manual

print("rendering...")

let ply = PolygonPIX(at: ._1024)

var img: NSImage!

let group = DispatchGroup()
group.enter()
try! PixelKit.main.render.engine.manuallyRender {
    img = ply.renderedImage!
    print("did render")
    group.leave()
}
group.wait()

let url: URL = outURL.appendingPathComponent("\(UUID().uuidString).png")
let data: Data = NSBitmapImageRep(data: img.tiffRepresentation!)!.representation(using: .png, properties: [:])!
try data.write(to: url)

print("done!")
