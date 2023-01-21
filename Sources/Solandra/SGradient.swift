import CoreGraphics
import SwiftUI

public enum SGradient {
  case linear(gradient: [SColorStop], start: CGPoint, end: CGPoint)
  case radial(gradient: [SColorStop], startCenter: CGPoint, startRadius: Double, endCenter: CGPoint, endRadius: Double)
  
  public var stops: [SColorStop] {
    switch self {
    case .linear(let gradient, _, _):
      return gradient
    case .radial(let gradient, _,_,_,_):
      return gradient
    }
  }
  
  public var gradient: CGGradient {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    return CGGradient(colorsSpace: colorSpace, colors: stops.map { $0.color.cg } as CFArray, locations: stops.map { CGFloat($0.location) })!
  }
}

public enum GradientBoundary {
  case topLeft, topMid, topRight, midLeft, midMid, midRight, bottomLeft, bottomMid, bottomRight
  
  public var relativePoint: CGPoint {
    switch self {
    case .topLeft:
      return CGPoint(0,0)
    case .topMid:
      return CGPoint(0.5,0)
    case .topRight:
      return CGPoint(1,0)
    case .midLeft:
      return CGPoint(0.5,0)
    case .midMid:
      return CGPoint(0.5,0.5)
    case .midRight:
      return CGPoint(1,0.5)
    case .bottomLeft:
      return CGPoint(1,0)
    case .bottomMid:
      return CGPoint(1,0.5)
    case .bottomRight:
      return CGPoint(1,1)
    }
  }
  
  public func absolutePoint(size: CGSize) -> CGPoint {
    relativePoint * size
  }
}


struct GradientPreviews: PreviewProvider {
  static var previews: some View {
    SolandraCanvas { context, size, s in
//      s.fill(SPath.regularPolygon(radius: size.width / 3, at: size.rect.center, n: 7), with: SGradient.linear(gradient: [
////        SColorStop(color: SColor(hue: 0.1, saturation: 1, brightness: 0.7),
////                   location: 0),
////        SColorStop(color: SColor(hue: 0, saturation: 1, brightness: 0.7),
////                   location: 0.3),
////        SColorStop(color: SColor(hue: 0.9, saturation: 1, brightness: 0.7),
////                   location: 0.95)
//        SColor.goldenrod.start,
//        SColor.red.mid,
//        SColor.crimson.threeQuarter,
//        SColor.hotpink.end
//
//       ], start: CGPoint.zero, end: CGPoint(0, 480) ))
      s.randomPoints(n: 20).forEach { pt in
        s.stroke(SPath.star(r1: 100, r2: 25, at: pt, n: 12), withSimpleGradientFrom: .topLeft, to: .bottomRight, stops: [
          SColor.orangered.with(opacity: 0.5).start,
          s.randomColor(saturation: 1, brightness: 0.7, opacity: 0.8).end
        ])
      }
      
      
      
//      s.setFill(color: SColor.goldenrod)
//      s.fill(SPath.star(r1: 100, r2: 50, at: size.rect.center, n: 12))
//
    }.frame(width: 480, height: 480)
  }
}


