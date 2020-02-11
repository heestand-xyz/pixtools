import AppKit
import LiveValues
import RenderKit
import PixelKit

print("pixtools")

// https://stackoverflow.com/questions/39815054/how-to-include-assets-resources-in-a-swift-package-manager-library
// dump(Bundle.allBundles)

PixelKit.main.render.engine.renderMode = .manual

let ply = PolygonPIX(at: ._1024)


//let group = DispatchGroup()
//group.enter()
try! PixelKit.main.render.engine.manuallyRender {
    let img: NSImage = ply.renderedImage!
    print("did render")
//    group.leave()
}
//group.wait()

print("final")
