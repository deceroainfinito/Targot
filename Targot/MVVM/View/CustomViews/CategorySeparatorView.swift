//
//  CategorySeparatorView.swift
//  Targot
//
//

import UIKit

class CategorySeparatorView: UIView {

  let darkStripeColor  = try! UIColor(hex: 0x7B8E9F)
  let lightStripeColor = try! UIColor(hex: 0xFEFFFF)

  let darkStripeWidth  = 1
  let lightStripeWidth = 1

  let darkStripeHeight  = 1
  let lightStripeHeight = 1

  override func draw(_ rect: CGRect) {
    let patternWidth  = darkStripeWidth + lightStripeWidth
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
