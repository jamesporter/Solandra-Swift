import CoreGraphics
import SwiftUI

#if os(macOS)
    public typealias OSColor = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
    public typealias OSColor = UIColor
#endif

public struct SColor {
  public var hue: Double
  public var saturation: Double
  public var brightness: Double
  public var opacity: Double = 1
  
  public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.opacity = opacity
  }
  
  public var cg: CGColor {
    OSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity).cgColor
  }
  
  public func stop(at: Double) -> SColorStop {
    SColorStop(color: self, location: at)
  }
  
  public var start: SColorStop {
    stop(at: 0)
  }
  
  public var quarter: SColorStop {
    stop(at: 0.25)
  }
  
  public var mid: SColorStop {
    stop(at: 0.5)
  }
  
  public var threeQuarter: SColorStop {
    stop(at: 0.75)
  }
  
  var end: SColorStop {
    stop(at: 1)
  }
  
  func with(hue: Double? = nil, saturation: Double? = nil, brightness: Double? = nil, opacity: Double? = nil) -> SColor {
    var copy = self
    if let hue = hue {
      copy.hue = hue
    }
    
    if let saturation = saturation {
      copy.saturation = saturation
    }
    
    if let brightness = brightness {
      copy.brightness = brightness
    }
    
    if let opacity = opacity {
      copy.opacity = opacity
    }
    
    return copy
  }
}

public struct SColorStop {
  public var color: SColor
  public var location: Double
  
  init(color: SColor, location: Double) {
    self.color = color
    self.location = location
  }
}
