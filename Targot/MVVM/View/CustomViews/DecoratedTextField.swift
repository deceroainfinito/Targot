//
//  TargotTextField.swift
//  Targot
//
//

import UIKit

public class DecoratedTextField: UIView {

  enum Style {
    case up, down, upAndDown, none
  }

  var textField: TextField!

  var iconView: UIImageView!

  var socialNetwork: SocialNetwork?

  var style = DecoratedTextField.Style.upAndDown

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init(withText text: String? = nil, placeholder: String, style: DecoratedTextField.Style = .upAndDown, socialNetwork: SocialNetwork? = nil) {
    self.init(frame: .zero)

    self.textField = TextField(withText: text, withPlaceholderText: placeholder, extraLeading: socialNetwork != nil)

    self.style           = style
    self.socialNetwork   = socialNetwork
    self.backgroundColor = .red

    setupViews()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    let upSep   = Separator(type: .up)
    let downSep = Separator(type: .down)

    if style == .up || style == .upAndDown {
      addSubview(upSep)
      self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: upSep, attribute: .width, multiplier: 1, constant: 0))
    }

    addSubview(textField)
    self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: textField, attribute: .width, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: textField, attribute: .left, multiplier: 1, constant: 0))

    if style == .down || style == .upAndDown {
      addSubview(downSep)
      self.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: downSep, attribute: .width, multiplier: 1, constant: 0))
    }

    switch style {
    case .up:
      addConstraintsWithFormat(format: "H:|[v0]|", views: upSep)
      addConstraintsWithFormat(format: "V:|[v0(1)]-0-[v1(\(136.cgPixels - 1))]|", views: upSep, textField)
    case .down:
      addConstraintsWithFormat(format: "H:|[v0]|", views: downSep)
      addConstraintsWithFormat(format: "V:|[v0(\(136.cgPixels - 1))]-0-[v1(1)]|", views: textField, downSep)
    case .upAndDown:
      addConstraintsWithFormat(format: "H:|[v0]|", views: upSep)
      addConstraintsWithFormat(format: "H:|[v0]|", views: downSep)
      addConstraintsWithFormat(format: "V:|[v0(1)]-0-[v1(\(136.cgPixels - 2))]-0-[v2(1)]|", views: upSep, textField, downSep)
    case .none:
      addConstraintsWithFormat(format: "V:|[v0(\(136.cgPixels))]|", views: textField)
    }


    if let icon = self.socialNetwork?.iconByState(.off) {
      iconView = UIImageView(image: icon)
      iconView.backgroundColor = .white

      addSubview(iconView)

      addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(40)]", views: iconView)
      addConstraintsWithFormat(format: "V:[v0(40)]", views: iconView)
      iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
  }

  func activateIcon(_ bool: Bool) {
    let state: SocialNetwork.State = bool ? .on : .off
    if let icon = self.socialNetwork?.iconByState(state) {
      iconView.image = icon
    }
  }
}
