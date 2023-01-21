import CoreGraphics

fileprivate let isoScaleW = sqrt(3.0) / 2.0
fileprivate let cosPIOver6 = cos(Double.pi / 6.0)
fileprivate let twoSinPIOver3 = 2 * sin(Double.pi / 3)
fileprivate let halfTanPIOver3 = 0.5 / tan(Double.pi / 3)

public enum SolandraUtilities {
  
  public static func isoTransform(height: Double = 1, x: Double, y: Double, z: Double) -> CGPoint {
    CGPoint((x - z) * isoScaleW * height, -height * (x / 2 + y + z / 2))
  }
  
  /**
   * NB Assumes integer grid
   * Supply a radius and boolean for whether it should be vertical (vertex at top) or not
   */
  public static func hexTransform(r: Double, vertical: Bool = true, x: Int, y: Int) -> CGPoint {
    if (vertical) {
      // Obvioulsy weird way to write but compiler could not typecheck errors...
      let xO: Double
      if y % 2 == 0 {
        xO = 2 * r * cosPIOver6 * x.d
      } else {
        xO = (2.0 * x.d - 1.0) * r * cosPIOver6
      }
      
      return CGPoint(xO, 1.5 * y.d * r)
    } else {
      return CGPoint(r * 1.5 * x.d, x % 2 == 0 ? 2 * r * cosPIOver6 * y.d : (2 * y.d - 1) * r * cosPIOver6)
    }
  }
  
  /**
   * NB Assumes integer grid, returns function that will return center of triangle and whether it should be flipped
   */
  public static func triTransform(s: Double, x: Int, y: Int) -> (at: CGPoint, flipped: Bool) {
    let r = s / twoSinPIOver3
    let h = s * halfTanPIOver3
    let isUp = (x + y) % 2 == 0
    
    if (isUp) {
      return (at: CGPoint(0.5 * s * x.d, (h + r) * y.d), flipped: false)
    } else {
      return (at: CGPoint(0.5 * s * x.d, (h + r) * y.d + h - r), flipped: true)
    }
  }
}
