import UIKit

import Foundation

public class TargotTextField: UITextField {
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  public convenience init(withPlaceholderText phText: String) {
    self.init(frame: .zero)

    let fieldFont = UIFont(name: FontClassName.abulaBold.rawValue, size: 102.cgPixels)
//
    let placeholderText = phText
    let placeholderFont = UIFont(name: FontClassName.abulaBold.rawValue, size: 102.cgPixels)

    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: placeholderFont!
    ]

    attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    backgroundColor = .white

    font = fieldFont

    contentVerticalAlignment = .bottom
  }

//  override public func textRect(forBounds bounds: CGRect) -> CGRect {
//    return UIEdgeInsetsInsetRect(bounds,
//                                 UIEdgeInsets(top: 30.cgPixels, left: 40.cgPixels, bottom: 0, right: 40.cgPixels))
//  }
//  override public func editingRect(forBounds bounds: CGRect) -> CGRect {
//    return UIEdgeInsetsInsetRect(bounds,
//                                 UIEdgeInsets(top: 30.cgPixels, left: 40.cgPixels, bottom: 0, right: 40.cgPixels))
//  }
//  override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//    return UIEdgeInsetsInsetRect(bounds,
//                                 UIEdgeInsets(top: 30.cgPixels, left: 40.cgPixels, bottom: 0, right: 40.cgPixels))
//  }

}
