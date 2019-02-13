//
//  UIExtensions.swift
//  Targot
//
//

import UIKit

extension UIScreen {
  public static var mainWidth: CGFloat {
    return UIScreen.main.bounds.width
  }
}

extension UIView {
  func addConstraintsWithFormat(format: String, views: UIView...) {
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

  func anchor(top: NSLayoutYAxisAnchor? = nil,
              leading: NSLayoutXAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              trailing: NSLayoutXAxisAnchor? = nil,
              padding: UIEdgeInsets = .zero,
              size: CGSize = .zero) {

    translatesAutoresizingMaskIntoConstraints = false

    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive              = true
    }
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive     = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive     = true
    }
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.width).isActive = true
    }
  }
}

public enum UIColorHexError: Error {
  case invalidRedValue
  case invalidBlueValue
  case invalidGreenVaue
}

public extension UIColor {

  static func rgb(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
    return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
  }

  convenience init(red: Int, green: Int, blue: Int) throws {
    if (red < 0 || red > 255) { throw UIColorHexError.invalidRedValue }
    if (green < 0 || green > 255) { throw UIColorHexError.invalidGreenVaue }
    if (blue < 0 || blue > 255) { throw UIColorHexError.invalidBlueValue }

    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  public convenience init(hex: Int) throws {
    try self.init(
      red: (hex >> 16) & 0xFF,
      green: (hex >> 8) & 0xFF,
      blue: hex & 0xFF
    )
  }
}
