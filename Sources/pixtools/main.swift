import AppKit
import LiveValues
import RenderKit
import PixelKit

print("pixtools")

// https://stackoverflow.com/questions/39815054/how-to-include-assets-resources-in-a-swift-package-manager-library

enum Arg: String {
    case metalLib = "--metalLib"
    func action(_ argStr: String) {
        switch self {
        case .metalLib:
            print("argStr:", argStr)
            pixelKitMetalLibURL = URL(fileURLWithPath: argStr)
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

print("pixelKitMetalLibURL:", pixelKitMetalLibURL?.path)

//PixelKit.main.render.engine.renderMode = .manual
//
//let ply = PolygonPIX(at: ._1024)
//
//
////let group = DispatchGroup()
////group.enter()
//try! PixelKit.main.render.engine.manuallyRender {
//    let img: NSImage = ply.renderedImage!
//    print("did render")
////    group.leave()
//}
////group.wait()
//
//print("final")
