//
//  CategoryButton.swift
//  Targot
//
//

import UIKit

public enum CategoryValue: Int {
  case none = 0, shopping, sport, leisure, barest

  public enum State: String { case on = "On", off = "Off" }

  static let descriptions = [
    NSLocalizedString("CategoryShopping", comment: ""),
    NSLocalizedString("CategorySports", comment: ""),
    NSLocalizedString("CategoryLeisure", comment: ""),
    NSLocalizedString("CategoryBars", comment: "")
    ]

  public var description: String {
    return Category.descriptions[self.rawValue]
  }

  public func iconByState(_ state: State) -> UIImage? {
    let iconName: String!

    switch self {
    case .none:
      iconName = ""
    case .shopping:
      iconName = NSLocalizedString("CategoryIconShopping\(state.rawValue)", comment: "")
    case .sport:
      iconName = NSLocalizedString("CategoryIconSports\(state.rawValue)", comment: "")
    case .leisure:
      iconName = NSLocalizedString("CategoryIconLeisure\(state.rawValue)", comment: "")
    case .barest:
      iconName = NSLocalizedString("CategoryIconBarest\(state.rawValue)", comment: "")
    }

    return UIImage(named: iconName)
  }
}

class CategoryButton: UIButton {

  var type: CategoryValue!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init(type: CategoryValue, state: CategoryValue.State) {
    self.init(frame: .zero)

    self.type = type
    tag       = type.rawValue
    setImage(type.iconByState(state), for: .normal)
  }

  func switchState(_ state: CategoryValue.State) {
    setImage(type.iconByState(state), for: .normal)
  }
}
