//
//  UpSeparator.swift
//  Targot
//
//

import UIKit

enum SeparatorType {
  case up, down
}

class Separator: UIView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(type: SeparatorType) {
    self.init(frame: .zero)

    if type == .up {
      backgroundColor = TargotColors.borderUp.color
    } else if type == .down {
      backgroundColor = TargotColors.borderDown.color
    }
  }
}
