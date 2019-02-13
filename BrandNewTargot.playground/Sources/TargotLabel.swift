//
//  TargotLabel.swift
//  Targot
//

import UIKit

class TargotLabel: UILabel {

  convenience init(text: String) {
    self.init(frame: CGRect.zero)

    self.font = UIFont(name: FontClassName.noyhrBold.rawValue, size: 48.pointsToPixels())
    self.text = text
    self.textAlignment = .left
    self.baselineAdjustment = .alignBaselines

    self.backgroundColor = TargotColors.lightGrisete.color

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
