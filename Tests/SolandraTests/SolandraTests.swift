import XCTest
import SnapshotTesting
import SwiftUI
import Solandra

final class SolandraTests: XCTestCase {
  
#if os(macOS)
    func testDrawingSomething() throws {
      let vc = NSHostingController(rootView: SolandraCanvas {
        context, size, solandra in
        context.setFillColor(NSColor(hue: 0, saturation: 1, brightness: 1, alpha: 1).cgColor)
        context.addRect(size.rect)
        context.fillPath()
      })
      
      vc.view.frame = NSRect(x: 0, y: 0, width: 1024, height: 640)
      
      assertSnapshot(matching: vc, as: .image(precision: 0.95, perceptualPrecision: 0.95))
    }
  
  func testRenderSomething() throws {
    let sketch: SolandraSketch = { context, size, solandra in
      context.setFillColor(NSColor(hue: 0, saturation: 1, brightness: 1, alpha: 1).cgColor)
      context.addRect(size.rect)
      context.fillPath()
    }
    
    let image = Solandra.renderImage(width: 1024, height: 800, sketch: sketch)
    assertSnapshot(matching: image, as: .image)
  }
#endif
}
