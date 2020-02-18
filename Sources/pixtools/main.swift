import AppKit
import LiveValues
import RenderKit
import PixelKit

print("pixtools")

let fm = FileManager.default

let callURL: URL = URL(fileURLWithPath: CommandLine.arguments.first!)

func getURL(_ path: String) -> URL {
    if path.starts(with: "/") {
        return URL(fileURLWithPath: path)
    }
    if path.starts(with: "~/") {
        let docsURL: URL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docsURL.appendingPathComponent(path.replacingOccurrences(of: "~/", with: ""))
    }
    return callURL.appendingPathComponent(path)
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
for (i, argStr) in CommandLine.arguments.enumerated() {
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

PixelKit.main.render.engine.renderMode = .manual


let ply = PolygonPIX(at: ._1024)


let group = DispatchGroup()
group.enter()
try! PixelKit.main.render.engine.manuallyRender {
    let img: NSImage = ply.renderedImage!
    print("did render")
    group.leave()
}
//group.wait()
group.notify(queue: .main) {
    print("done")
    exit(EXIT_SUCCESS)
}

RunLoop.current.add(Timer(timeInterval: 1.0, repeats: false, block: { _ in
    print("timeout")
}), forMode: .common)

dispatchMain()
print("final")
