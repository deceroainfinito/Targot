//
//  DecoratedButton.swift
//  Targot
//
//

import UIKit

class DecoratedButton: UIView {

  var label: UILabel = {
    let label = UILabel(frame: .zero)

    label.font      = FontBuilder.noyhRRegular.uiFont(size: FontBuilder.FontSize.bigField.cgPixels)
    label.textColor = TargotColors.darkGrisete.color

    return label
  }()

  var image: UIImageView = UIImageView(image: #imageLiteral(resourceName: "arrow_right"))

  var style = DecoratedTextField.Style.upAndDown

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(withText text: String, style: DecoratedTextField.Style = .upAndDown) {
    self.init(frame: .zero)

    self.backgroundColor = .white

    label.text = text
    self.style = style

    setupViews()
  }

  func setupViews() {

    switch style {
    case .upAndDown:
      setupUpAndDown()
    case .up:
      setupUp()
    case .down:
      setupDown()
    case .none:
      setupNone()
    }
  }

  func setupUpAndDown() {
    let upSep   = Separator(type: .up)
    let downSep = Separator(type: .down)

    addSubview(upSep)
    addSubview(label)
    addSubview(image)
    addSubview(downSep)

    addConstraintsWithFormat(format: "H:|[v0]|", views: upSep)
    addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0]-[v1(\(60.cgPixels))]-\(40.cgPixels)-|", views: label, image)
    addConstraintsWithFormat(format: "H:|[v0]|", views: downSep)
    addConstraintsWithFormat(format: "V:|[v0(1)]-0-[v1(\(136.cgPixels - 2))]-0-[v2(1)]|", views: upSep, label, downSep)

    addConstraintsWithFormat(format: "V:[v0(\(60.cgPixels))]", views: image)
    image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }

  func setupUp() {
    let sep = Separator(type: .up)

    addSubview(sep)
    addSubview(label)
    addSubview(image)

    addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width * 0.7))]-0-[v1]|", views: label, image)
    addConstraintsWithFormat(format: "V:|[v0(1)]-0-[v1(\(136.cgPixels - 1))]|", views: sep, label)
    addConstraintsWithFormat(format: "V:[v0(\(60.cgPixels))]", views: image)
    image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }

  func setupDown() {
    let sep = Separator(type: .down)

    addSubview(label)
    addSubview(image)
    addSubview(sep)

    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width * 0.7))]-0-[v1]|", views: label, image)
    addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
    addConstraintsWithFormat(format: "V:|[v1(\(136.cgPixels - 1))]-[v0(\(60.cgPixels))]|", views: label, sep)
    image.topAnchor.constraint(equalTo: label.topAnchor)
  }

  func setupNone() {
    addSubview(label)
    label.topAnchor.constraint(equalTo: self.topAnchor)
    label.leftAnchor.constraint(equalTo: self.leftAnchor)
    label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
    addSubview(image)
    image.topAnchor.constraint(equalTo: self.topAnchor)
    image.leftAnchor.constraint(equalTo: label.rightAnchor)
    image.rightAnchor.constraint(equalTo: self.rightAnchor)
  }
}
