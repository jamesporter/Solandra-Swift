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
  
  func testAPattern() throws {
    let image = Solandra.renderImage(width: 1024, height: 1024) { context, size, solandra in
      context.setFillColor(NSColor(hue: 0.63, saturation: 0.74, brightness: 0.1, alpha: 1).cgColor)
      context.addRect(size.rect)
      context.fillPath()
      
      
      var path = SPath(start: CGPoint(100,100))
      path.addLine(to: CGPoint(924, 100))
      path.addLine(to:  CGPoint(924, 924))
      path.addLine(to: CGPoint(100, 924))
      path.close()
      
      var paths = path.exploded().flatMap {
        $0.exploded(magnitude: 2, scale: 0.8)
      }.flatMap { try! $0.segmented() }
      
      paths = solandra.shuffled(items: paths)
      
      
      paths.enumerated().forEach { (i, p) in
        context.setFillColor(NSColor(hue: i.d / 100, saturation: 0.74, brightness: 0.6, alpha: 0.9).cgColor)
        p.addTo(context: context)
        context.fillPath()
      }
    }
    assertSnapshot(matching: image, as: .image)
  }
  
  func testStar() throws {
    let image = Solandra.renderImage(width: 1024, height: 1024) { context, size, s in
//      context.setFillColor(NSColor(hue: 0.63, saturation: 0.74, brightness: 0.1, alpha: 1).cgColor)
//      context.addRect(size.rect)
//      context.fillPath()
      s.background(0.63, 0.74, 0.1)
      
//      context.setFillColor(NSColor(hue: 0.1, saturation: 0.74, brightness: 0.6, alpha: 0.8).cgColor)
      s.setFill(0.1, 0.74, 0.6, 0.8)
      let path = try! SPath.star(r1: 320, r2: 120, at: size.rect.center, n: 12)
//      path.addTo(context: context)
//      context.fillPath()
      s.fill(path)
    }
    assertSnapshot(matching: image, as: .image)
  }
  
  func testSpiral() throws {
    let image = Solandra.renderImage(width: 1024, height: 1024) { context, size, s in
      s.background(0.23, 0.74, 0.1)
      s.setStroke(0.93, 0.74, 0.6, 0.8)
      
      // TODO next look at this
      context.setLineWidth(10)
      context.setLineCap(.round)
      context.setLineJoin(.round)
      
      let path = SPath.spiral(at: size.rect.center, n: 1000, l: 20)
      s.stroke(path)
    }
    assertSnapshot(matching: image, as: .image)
  }
  
  func testRegular() throws {
    let image = Solandra.renderImage(width: 1024, height: 1024) { context, size, s in
      s.background(0.23, 0.74, 0.1)
      
      s.forTiling(n: 5) { area, i in
        s.setFill(0.93 - 0.02 * i.d, 0.74, 0.6, 0.8)
        let path = SPath.regularPolygon(radius: min(area.width, area.height), at: area.center, n: i + 5)
        s.fill(path)
      }
    }
    assertSnapshot(matching: image, as: .image)
  }
#endif
}
