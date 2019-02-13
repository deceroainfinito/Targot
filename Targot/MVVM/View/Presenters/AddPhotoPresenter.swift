//
//  AddPhotoPresenter.swift
//  Targot
//
//

import UIKit

class AddPhotoPresenter: Presenter {

  var backgroundView: UIView = {
    let bv = UIView(frame: .zero)

    bv.backgroundColor = UIColor.white
    bv.layer.cornerRadius = 10.cgPixels

    return bv
  }()

  var libraryButton: UIButton = {
    let lb = UIButton(frame: .zero)

    lb.setImage(#imageLiteral(resourceName: "button_done_en"), for: .normal)

    return lb
  }()

  var cameraButton: UIButton = {
    let cb = UIButton(frame: .zero)

    cb.setImage(#imageLiteral(resourceName: "button_done_en"), for: .normal)

    return cb
  }()

  var cancelButton: UIButton = {
    let cb = UIButton(frame: .zero)

    cb.setImage(#imageLiteral(resourceName: "button_done_en"), for: .normal)

    return cb
  }()

  let buttonStack: UIStackView = {
    let bs = UIStackView()

    bs.spacing      = 10
    bs.axis         = .vertical
    bs.alignment    = .center
    bs.distribution = .fillEqually

    return bs
  }()


  override func setupViews() {

    viewController.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    viewController.view.isOpaque = false

    viewController.view.addSubview(backgroundView)

    viewController.view.addConstraintsWithFormat(format: "H:[v0(\(850.cgPixels))]", views: backgroundView)
    viewController.view.addConstraintsWithFormat(format: "V:[v0(\(750.cgPixels))]", views: backgroundView)

    viewController.view.addConstraint(
      NSLayoutConstraint(item: backgroundView,
                         attribute: .centerX,
                         relatedBy: .equal,
                         toItem: viewController.view,
                         attribute: .centerX,
                         multiplier: 1,
                         constant: 0))

    viewController.view.addConstraint(
      NSLayoutConstraint(item: backgroundView,
                         attribute: .centerY,
                         relatedBy: .equal,
                         toItem: viewController.view,
                         attribute: .centerY,
                         multiplier: 1,
                         constant: 0))

    buttonStack.addArrangedSubview(libraryButton)
    buttonStack.addConstraintsWithFormat(format: "H:[v0(175)]", views: libraryButton)
    buttonStack.addConstraintsWithFormat(format: "V:[v0(32)]", views: libraryButton)

    if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
      buttonStack.addArrangedSubview(cameraButton)
      buttonStack.addConstraintsWithFormat(format: "H:[v0(175)]", views: cameraButton)
      buttonStack.addConstraintsWithFormat(format: "V:[v0(32)]", views: cameraButton)
    }

    backgroundView.addSubview(buttonStack)
    backgroundView.addSubview(cancelButton)

    backgroundView.addConstraintsWithFormat(format: "V:[v0]", views: buttonStack)
    viewController.view.addConstraint(
      NSLayoutConstraint(item: backgroundView,
                         attribute: .centerX,
                         relatedBy: .equal,
                         toItem: buttonStack,
                         attribute: .centerX,
                         multiplier: 1,
                         constant: 0))
    viewController.view.addConstraint(
      NSLayoutConstraint(item: backgroundView,
                         attribute: .centerY,
                         relatedBy: .equal,
                         toItem: buttonStack,
                         attribute: .centerY,
                         multiplier: 1,
                         constant: 32))

    backgroundView.addConstraintsWithFormat(format: "H:[v0(175)]", views: cancelButton)
    backgroundView.addConstraintsWithFormat(format: "V:[v0(32)]", views: cancelButton)
    backgroundView.addConstraint(
      NSLayoutConstraint(item: buttonStack,
                         attribute: .centerX,
                         relatedBy: .equal,
                         toItem: cancelButton,
                         attribute: .centerX,
                         multiplier: 1,
                         constant: 0))
    backgroundView.addConstraint(
      NSLayoutConstraint(item: cancelButton,
                         attribute: .top,
                         relatedBy: .equal,
                         toItem: buttonStack,
                         attribute: .top,
                         multiplier: 1,
                         constant: 100))
  }
}
