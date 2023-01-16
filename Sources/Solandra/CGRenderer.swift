#if os(OSX)
  import AppKit
  public typealias Image = NSImage
#elseif os(iOS)
  import UIKit
  public typealias Image = UIImage
#endif

extension Solandra {
  /**
    Platform normalised rendering boilerplate; configure a size and write the rendering code with the CGContext;
   */
  public static func renderImage(width: Int, height: Int, seed: UInt64 = 0, sketch: SolandraSketch) -> Image {
    let size = CGSize(width.d, height.d)
    let ctx = createCGContext(width: width, height: height)
    
    let solandra = Solandra(seed: seed)
    solandra.context = ctx
    solandra.time = 0
    solandra.size = size
    
    sketch(ctx, size, solandra)
    
    let image = produceImage(context: ctx, width: width, height: height)
    endCGContext()
    return image
  }
  
  public static func renderData(width: Int, height: Int, seed: UInt64 = 0, sketch: SolandraSketch) -> Data? {
    let image = renderImage(width: width, height: height, seed: seed, sketch: sketch)
    return imageToData(image: image)
  }
  
  static func createCGContext(width: Int, height: Int) -> CGContext {
    #if os(OSX)
    return CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: CGColorSpace(name: CGColorSpace.displayP3)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    #elseif os(iOS)
      UIGraphicsBeginImageContext(CGSize(width: width, height: height))
      return UIGraphicsGetCurrentContext()!
    #endif
  }
  
  static func endCGContext() {
    #if os(OSX)
      // No-op
    #elseif os(iOS)
      UIGraphicsEndImageContext()
    #endif
  }
  
  static func produceImage(context: CGContext, width: Int, height: Int) -> Image {
    #if os(OSX)
      return NSImage(cgImage: context.makeImage()!, size: NSSize(width: width, height: height))
    #elseif os(iOS)
      return UIGraphicsGetImageFromCurrentImageContext()!
    #endif
  }
  
  static func imageToData(image: Image) -> Data? {
    #if os(OSX)
      guard let tiffRepresentation = image.tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
      return bitmapImage.representation(using: .png, properties: [:])
    #elseif os(iOS)
      return image.pngData()
    #endif
  }
}
