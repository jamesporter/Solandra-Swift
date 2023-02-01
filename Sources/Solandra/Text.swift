import SwiftUI
import CoreText

extension Solandra {
// text is mildly horrifying with things like CoreText; wanted some simple way to add, may improve
  public func text(_ text: String, fontName: String = "SF Pro Text", fontSize: Double, color: SColor, at: CGPoint) {
//    TODO probably just set this once?
    context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)

    let font = CTFontCreateWithName(fontName as CFString, fontSize, nil)

    let attributes: [NSAttributedString.Key : Any] = [.font: font, .foregroundColor: color.cg]

    let attributedString = NSAttributedString(string: text,
                                              attributes: attributes)
    let line = CTLineCreateWithAttributedString(attributedString)

    context.textPosition = at

    CTLineDraw(line, context)
  }
}


struct TextPreviews: PreviewProvider {
  static var previews: some View {
    SolandraCanvas { context, size, s in
      s.background(0.1, 0.2, 0.95)
      for i in 1...10 {
        s.text("Hello World \(i)", fontName: "AppleSDGothicNeo", fontSize: i.d + 12, color: SColor(hue: 0.54 + (i.d / 40.0), saturation: 0.8, brightness: 0.7, opacity: 0.9), at: size.point * i.d / 12 + s.randomPoint() * 0.05)
      }
    }.frame(width: 320, height: 320)
  }
}
