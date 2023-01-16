import XCTest
import SnapshotTesting
import SwiftUI
import Solandra

final class SolandraTests: XCTestCase {
#if os(iOS)
    func testDrawingSomething() throws {
      let vc = UIHostingController(rootView: SolandraCanvas {
        context, size, solandra in
        context.setFillColor(UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1).cgColor)
        context.addRect(size.rect)
        context.fillPath()
      })
      vc.view.frame = UIScreen.main.bounds
      
      assertSnapshot(matching: vc, as: .image)
    }
  
  func testRenderSomething() throws {
    let sketch: SolandraSketch = { context, size, solandra in
      context.setFillColor(UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1).cgColor)
      context.addRect(size.rect)
      context.fillPath()
    }
    
    let image = Solandra.renderImage(width: 1024, height: 800, sketch: sketch)
    assertSnapshot(matching: image, as: .image)
  }
#endif
}
