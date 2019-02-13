//
//  TargotTextField.swift
//  Targot
//
//
import UIKit

public class TargotSeparatedTextField: UIView {
  let upSeparator: UIView = {
    let upSprt = UIView()
    upSprt.backgroundColor = TargotColors.borderUp.color

    return upSprt
  }()

  let textField = TargotTextField(withPlaceholderText: NSLocalizedString("BarLaPlata", comment: ""))

  let bottomSeparator: UIView = {
    let bSprt = UIView()

    bSprt.backgroundColor = TargotColors.borderDown.color

    return bSprt
  }()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    addSubview(upSeparator)
    addSubview(textField)
    addSubview(bottomSeparator)

    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: upSeparator)
    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: textField)
    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: bottomSeparator)

    addConstraintsWithFormat(format: "V:|[v0(1)]-0-[v1(\(148.pixels - 2))]-0-[v2(1)]|",
                             views: upSeparator, textField, bottomSeparator)
  }
}
