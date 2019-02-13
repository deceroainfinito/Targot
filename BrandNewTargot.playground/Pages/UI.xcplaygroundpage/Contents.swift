//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

extension Int {
  func pointsToPixels() -> CGFloat {
    return CGFloat(self) / UIScreen.main.scale
  }
}

let fontURL = Bundle.main.url(forResource: "NoyhR-Bold", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
let font = UIFont(name: "NoyhR-Bold", size: 48.pointsToPixels())!

let fontURL2 = Bundle.main.url(forResource: "Abula-Bold", withExtension: "otf")
CTFontManagerRegisterFontsForURL(fontURL2! as CFURL, CTFontManagerScope.process, nil)
let font2 = UIFont(name: "Abula-Bold", size: 102.pointsToPixels())!

let fontURL3 = Bundle.main.url(forResource: "NoyhR-Medium", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL2! as CFURL, CTFontManagerScope.process, nil)

let font3 = UIFont(name: "Abula-Bold", size: 42.pointsToPixels())!

let view  = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 192))
let label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 64))
let label2 = UILabel(frame: CGRect(x: 0, y: 64, width: 400, height: 64))
let label3 = UILabel(frame: CGRect(x: 0, y: 128, width: 400, height: 64))

let attributes: [NSAttributedStringKey: Any] = [
  NSAttributedStringKey.font: font
]

label.attributedText = NSAttributedString(string: "PEPE LUIS", attributes: attributes)

view.backgroundColor = .white
//view.addSubview(label)

let attributes2: [NSAttributedStringKey: Any] = [
  NSAttributedStringKey.font: font2
]

label2.attributedText = NSAttributedString(string: "PEPE LUIS", attributes: attributes2)

view.backgroundColor = .white
//view.addSubview(label2)

let attributes3: [NSAttributedStringKey: Any] = [
  NSAttributedStringKey.font: font3,
  NSAttributedStringKey.foregroundColor: UIColor.darkGray
]

label3.attributedText = NSAttributedString(string: "PEPE LUIS", attributes: attributes3)

view.backgroundColor = .white
//view.addSubview(label3)

let nameField: UITextField = {
  let nameF = UITextField(frame: CGRect(x: 0, y: 0, width: 400, height: 40))

  let placeholderText = NSLocalizedString("Bar La Plata", comment: "")
  let placeholderFont = font3

  let attributes: [NSAttributedStringKey: Any] = [
    NSAttributedStringKey.font: placeholderFont
  ]

  nameF.borderStyle = .bezel

  nameF.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
  nameF.backgroundColor = .white
  nameF.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom

  return nameF
}()

public extension UIColor {

  static func rgb(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
    return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
  }

  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  public convenience init(hex: Int) {
    self.init(
      red: (hex >> 16) & 0xFF,
      green: (hex >> 8) & 0xFF,
      blue: hex & 0xFF
    )
  }
}

class CategorySeparatorView: UIView {

  let darkStripeColor = UIColor(hex: 0x7C8FA0)
  let lightStripeColor = UIColor(hex: 0xFEFFFF)

  let darkStripeWidth = 1
  let lightStripeWidth = 1

  let darkStripeHeight = 1
  let lightStripeHeight = 1

  override func draw(_ rect: CGRect) {
    let patternWidth = darkStripeWidth + lightStripeWidth
    let patternHeight = min(darkStripeHeight, lightStripeHeight)

    let patternSize = CGSize(width: patternWidth, height: patternHeight)

    let context = UIGraphicsGetCurrentContext()

    UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0)

    let darkStripePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: darkStripeWidth, height: darkStripeHeight))
    darkStripeColor.setFill()
    darkStripePath.fill()

    let lightStripePath =
      UIBezierPath(rect: CGRect(x: darkStripeWidth, y: 0, width: lightStripeWidth, height: lightStripeHeight))
    lightStripeColor.setFill()
    lightStripePath.fill()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    UIColor(patternImage: image!).setFill()

    context?.fill(rect)
  }
}

let separator = CategorySeparatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))

view.addSubview(separator)

PlaygroundPage.current.liveView = view
