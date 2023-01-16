@_exported import CGExtensions
import PseudoRandom
import SwiftUI


public class Solandra {
  var rng: PseudoRandom
  
  // We set these from whatever context it is called. Whlie the ! may be dangerous, this is typically set by this framework in a helper view or other utility.
  var context: CGContext!
  var time = Double.zero
  var size: CGSize!
  
  public init(seed: UInt64 = 0) {
    rng = PseudoRandom(seed: seed)
  }
  
  public var aspectRatio: Double {
    size.width / size.height
  }
}


public typealias SolandraSketch = (CGContext, CGSize, Solandra) -> Void

public struct SolandraCanvas: View {
  var sketch: SolandraSketch
  var time: Double
  @State private var solandra: Solandra
  
  public init(seed: UInt64 = 0, sketch: @escaping SolandraSketch) {
    self.sketch = sketch
    self.time = Date.now.timeIntervalSince1970
    self.solandra = Solandra(seed: seed)
  }
  
  public var body: some View {
    Canvas {context, size in
      context.withCGContext { cgContext in
        solandra.context = cgContext
        solandra.time = time
        solandra.size = size
        
        sketch(cgContext, size, solandra)
      }
    }
  }
}

public struct SolandraAnimatedCanvas: View {
  var sketch: SolandraSketch
  @State private var solandra: Solandra
  
  public init(seed: UInt64 = 0, paused: Bool = false, sketch: @escaping SolandraSketch) {
    self.sketch = sketch
    self.solandra = Solandra(seed: seed)
  }
  
  public var body: some View {
    TimelineView(.animation) { timeLineContext in
      let time: Double = timeLineContext.date.timeIntervalSince1970
      
      Canvas {context, size in
        context.withCGContext { cgContext in
          solandra.context = cgContext
          solandra.time = time
          solandra.size = size
          
          sketch(cgContext, size, solandra)
        }
      }
    }
  }
}

