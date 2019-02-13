//
//  TargotCategoryView.swift
//  Targot
//
//

import UIKit

class CategoryView: UIView {

  var shoppingButton = CategoryButton(type: .shopping, state: .off)
  var sportButton    = CategoryButton(type: .sport, state: .off)
  var leisureButton  = CategoryButton(type: .leisure, state: .off)
  var brButton       = CategoryButton(type: .barest, state: .off)

  var stackView: UIStackView = {
    let stackView = UIStackView()

    stackView.axis = .horizontal
    stackView.distribution = UIStackView.Distribution.equalCentering
//    stackView.alignment = UIStackViewAlignment.center

    return stackView
  }()

  let vSeparator: UIView = {
    let vSeparator = UIView()

    vSeparator.backgroundColor = TargotColors.borderUp.color

    vSeparator.addConstraint(NSLayoutConstraint(item: vSeparator,
                                        attribute: NSLayoutConstraint.Attribute.width,
                                        relatedBy: .equal,
                                        toItem: vSeparator,
                                        attribute: NSLayoutConstraint.Attribute.width,
                                        multiplier: 1,
                                        constant: 0))

    return vSeparator
  }()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  convenience init() {
    self.init(frame: .zero)
  }

  func setupViews() {

    [shoppingButton, sportButton, leisureButton, brButton].forEach { (button) in
      if !stackView.arrangedSubviews.isEmpty {

        let separator = CategorySeparatorView()
        separator.widthAnchor.constraint(equalToConstant: 2).isActive = true

        stackView.addArrangedSubview(separator)
      }

      stackView.addArrangedSubview(button)
    }

    addSubview(stackView)

    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: stackView)
    addConstraintsWithFormat(format: "V:|[v0(\(150.pixels))]|", views: stackView)

    stackView.arrangedSubviews.forEach { (separator) in
      if separator.isKind(of: Separator.self) {
        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8).isActive = true
      }
    }
  }

  func setCategory(_ category: CategoryValue) {
    [shoppingButton, sportButton, leisureButton, brButton].forEach { (button) in
      button.switchState(button.type == category ? .on : .off)
    }
  }
}
