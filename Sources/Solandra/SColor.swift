import CoreGraphics
import SwiftUI

#if os(macOS)
    typealias OSColor = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
    typealias OSColor = UIColor
#endif

public struct SColor {
  public var hue: Double
  public var saturation: Double
  public var brightness: Double
  public var opacity: Double = 1
  
  init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) {
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.opacity = opacity
  }
  
  var cg: CGColor {
    OSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity).cgColor
  }
  
  func stop(at: Double) -> SColorStop {
    SColorStop(color: self, location: at)
  }
  
  var start: SColorStop {
    stop(at: 0)
  }
  
  var quarter: SColorStop {
    stop(at: 0.25)
  }
  
  var mid: SColorStop {
    stop(at: 0.5)
  }
  
  var threeQuarter: SColorStop {
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
