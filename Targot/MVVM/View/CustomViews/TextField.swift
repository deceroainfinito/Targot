//
//  TextField.swift
//  Targot
//
//

import UIKit

public class TextField: UITextField {

  var leading: CGFloat!

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  public convenience init(withText text: String? = nil, withPlaceholderText phText: String, extraLeading: Bool = false) {
    self.init(frame: .zero)

    self.leading = extraLeading ? 200.cgPixels : 40.cgPixels

    let fieldFont = FontBuilder.noyhRRegular.uiFont(size: FontBuilder.FontSize.bigField.cgPixels)

    let placeholderText = NSLocalizedString(phText, comment: "")
    let placeholderFont = UIFont(name: FontBuilder.abulaBold.name.rawValue, size: FontBuilder.FontSize.bigField.cgPixels)

    if let text = text {
      let attrText = NSLocalizedString(text, comment: "")
      self.attributedText = NSAttributedString(string: attrText)
    }

    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: placeholderFont!
    ]

    self.attributedPlaceholder    = NSAttributedString(string: placeholderText, attributes: attributes)
    self.backgroundColor          = .white
    self.font                     = fieldFont
    self.textColor                = TargotColors.darkGrisete.color
    self.contentVerticalAlignment = .bottom
  }

  override public func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 20.cgPixels, left: leading, bottom: 5.cgPixels, right: 0))
  }
  override public func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 20.cgPixels, left: leading, bottom: 5.cgPixels, right: 0))
  }
  override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 20.cgPixels, left: leading, bottom: 5.cgPixels, right: 0))
  }
}
