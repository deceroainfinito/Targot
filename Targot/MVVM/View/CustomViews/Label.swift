//
//  TargotLabel.swift
//  Targot
//
//

import UIKit

class Label: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init(withText text: String) {
    self.init(frame: .zero)

    self.font            = FontBuilder.noyhrBold.uiFont(size: FontBuilder.FontSize.label.cgPixels)
    self.text            = text
    self.textAlignment   = .left
    self.backgroundColor = TargotColors.lightGrisete.color
  }
}
