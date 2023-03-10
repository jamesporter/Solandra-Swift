@_exported import CGExtensions
import PseudoRandom
import SwiftUI

public class Solandra {
  var rng: PseudoRandom
  
  // We set these from whatever context it is called. Whlie the ! may be dangerous, this is typically set by this framework in a helper view or other utility.
  public internal(set) var context: CGContext!
  public internal(set) var time = Double.zero
  public internal(set) var size: CGSize!
  
  public init(seed: UInt64 = 0) {
    rng = PseudoRandom(seed: seed)
  }
  
  public var aspectRatio: Double {
    size.width / size.height
  }
  
  public func setFill(_ hue: Double, _ saturation: Double, _ brightness: Double, _ opacity: Double = 1) {
    context.setFillColor(SColor(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity).cg)
  }
  
  public func setStroke(_ hue: Double, _ saturation: Double, _ brightness: Double, _ opacity: Double = 1) {
    context.setStrokeColor(SColor(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity).cg)
  }
  
  public func background(_ hue: Double, _ saturation: Double, _ brightness: Double, _ opacity: Double = 1) {
    setFill(hue, saturation, brightness, opacity)
    context.addRect(size.rect)
    context.fillPath()
  }
  
  public func setFill(color: SColor) {
    context.setFillColor(color.cg)
  }
  
  public func setStroke(color: SColor) {
    context.setStrokeColor(color.cg)
  }
  
  public func background(color: SColor) {
    setFill(color: color)
    context.addRect(size.rect)
    context.fillPath()
  }
  
  public func fill(_ path: SPath) {
    path.addTo(context: context)
    context.fillPath()
  }
  
  public func stroke(_ path: SPath) {
    path.addTo(context: context)
    context.strokePath()
  }
  
  private func draw(gradient: SGradient) {
    switch gradient {
    case let .linear(_, start, end):
      context.drawLinearGradient(gradient.gradient, start: start, end: end, options: [])
    case let .radial(_, startCenter, startRadius, endCenter, endRadius):
      context.drawRadialGradient(gradient.gradient, startCenter: startCenter, startRadius: startRadius, endCenter: endCenter, endRadius: endRadius, options: [])
    }
  }
  
  public func fill(_ path: SPath, with gradient: SGradient) {
    context.saveGState()
    path.addTo(context: context)
    context.clip()
    draw(gradient: gradient)
    context.restoreGState()
  }
  
  public func stroke(_ path: SPath, with gradient: SGradient) {
    context.saveGState()
    path.addTo(context: context)
    context.replacePathWithStrokedPath()
    context.clip()
    draw(gradient: gradient)
    context.restoreGState()
  }
  
  public func fill(_ path: SPath, withSimpleGradientFrom from: GradientBoundary, to: GradientBoundary, stops: [SColorStop]) {
    fill(path, with: .linear(gradient: stops, start: from.absolutePoint(size: size), end: to.absolutePoint(size: size)))
  }
  
  public func stroke(_ path: SPath, withSimpleGradientFrom from: GradientBoundary, to: GradientBoundary, stops: [SColorStop]) {
    stroke(path, with: .linear(gradient: stops, start: from.absolutePoint(size: size), end: to.absolutePoint(size: size)))
  }
  
  public func fill(cgPath: CGPath) {
    context.addPath(cgPath)
    context.fillPath()
  }
  
  public func stroke(cgPath: CGPath) {
    context.addPath(cgPath)
    context.strokePath()
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

