//
//  RoundedButton.swift
//  Targot
//
//

import UIKit

enum RoundedButtonType {
  case geo, done

  func iconName() -> String {
    switch self {
    case .geo:
      return NSLocalizedString("GeoLocationButton", comment: "")
    case .done:
      return NSLocalizedString("DoneButton", comment: "")
    }
  }
}

class RoundedButton: UIButton {

  static let width  = 175
  static let height = 32

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init(type: RoundedButtonType) {
    self.init(frame: .zero)
    self.setImage(UIImage(named: type.iconName()), for: .normal)
  }
}
