//
//  UIExtensions.swift
//  Targot
//

import UIKit

extension UIView {
  public func addConstraintsWithFormat(format: String, views: UIView...) {
    var viewsDict = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDict[key] = view
    }

    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                  options: NSLayoutConstraint.FormatOptions(),
                                                  metrics: nil,
                                                  views: viewsDict))
  }
}

public extension UIColor {

  public static func rgb(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
    return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
  }

  public convenience init(red: Int, green: Int, blue: Int) {
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
