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
    let gradient = CGGradient(colorsSpace: colorSpace, colors: stops.map { $0.color.cg } as CFArray, locations: stops.map { CGFloat($0.location) })
    
    if gradient == nil {
      print("wft")
    }
    return gradient!
  }
}

struct GradientPreviews: PreviewProvider {
  static var previews: some View {
    SolandraCanvas { context, size, s in
      s.fill(SPath.regularPolygon(radius: size.width / 3, at: size.rect.center, n: 7), with: SGradient.linear(gradient: [
        SColorStop(color: SColor(hue: 0.1, saturation: 1, brightness: 0.7),
                   location: 0),
        SColorStop(color: SColor(hue: 0, saturation: 1, brightness: 0.7),
                   location: 0.3),
        SColorStop(color: SColor(hue: 0.9, saturation: 1, brightness: 0.7),
                   location: 0.95)
       ], start: CGPoint.zero, end: CGPoint(480, 480) ))
    }.frame(width: 480, height: 480)
  }
}


