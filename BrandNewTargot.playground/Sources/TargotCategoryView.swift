////
////  TargotCategoryView.swift
////  Targot
////
//
//import UIKit
//
//public class TargotCategoryView: UIView {
//
//  var stackView: UIStackView = {
//    let sv = UIStackView()
//
//    sv.axis = .horizontal
//    sv.distribution = .equalCentering
//    sv.alignment = .center
//
//    return sv
//  }()
//
//  class CategorySeparatorView: UIView {
//
//    let darkStripeColor  = UIColor(hex: 0x7B8E9F)
//    let lightStripeColor = UIColor(hex: 0xFEFFFF)
//
//    let darkStripeWidth  = 1
//    let lightStripeWidth = 1
//
//    let darkStripeHeight  = 1
//    let lightStripeHeight = 1
//
//
//    override func draw(_ rect: CGRect) {
//      let patternWidth  = darkStripeWidth + lightStripeWidth
//      let patternHeight = min(darkStripeHeight, lightStripeHeight)
//
//      let patternSize = CGSize(width: patternWidth, height: patternHeight)
//
//      let context = UIGraphicsGetCurrentContext()
//
//      UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0)
//
//      let darkStripePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: darkStripeWidth, height: darkStripeHeight))
//      darkStripeColor.setFill()
//      darkStripePath.fill()
//
//      let lightStripePath =
//          UIBezierPath(rect: CGRect(x: darkStripeWidth, y: 0, width: lightStripeWidth, height: lightStripeHeight))
//      lightStripeColor.setFill()
//      lightStripePath.fill()
//
//      let image = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//
//      UIColor(patternImage: image!).setFill()
//
//      context?.fill(rect)
//    }
//  }
//
//  var categories: [UIButton] = {
//    var buttons:[UIButton] = []
//
//    let shoppingButton = UIButton(frame: .zero)
//
//    shoppingButton.setImage(#imageLiteral(resourceName: "category_shopping"), for: .normal)
//    shoppingButton.tag = 0
//
//    let sportButton = UIButton(frame: .zero)
//    sportButton.setImage(#imageLiteral(resourceName: "category_sport"), for: .normal)
//    sportButton.tag = 1
//
//    let leisureButton = UIButton(frame: .zero)
//    leisureButton.setImage(#imageLiteral(resourceName: "category_leisure"), for: .normal)
//    leisureButton.tag = 2
//
//    let brButton = UIButton(frame: .zero)
//    brButton.setImage(#imageLiteral(resourceName: "category_b_r"), for: .normal)
//    brButton.tag = 3
//
//    buttons.append(shoppingButton)
//    buttons.append(sportButton)
//    buttons.append(leisureButton)
//    buttons.append(brButton)
//
//    return buttons
//  }()
//
//  let vSeparator: UIView = {
//    let vs = UIView()
//
//    vs.backgroundColor = TargotColors.borderUp.color
//
//    vs.addConstraint(NSLayoutConstraint(item: vs,
//                                        attribute: NSLayoutAttribute.width,
//                                        relatedBy: .equal,
//                                        toItem: vs,
//                                        attribute: NSLayoutAttribute.width,
//                                        multiplier: 1,
//                                        constant: 0))
//
//
//    return vs
//  }()
//
//  public required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//
//  public  override init(frame: CGRect) {
//    super.init(frame: frame)
//
//    setupViews()
//  }
//
//  func setupViews() {
//    categories.forEach { (button) in
//      if stackView.arrangedSubviews.count > 0 {
//
//        let separator = CategorySeparatorView()
//        separator.widthAnchor.constraint(equalToConstant: 2).isActive = true
//
//        stackView.addArrangedSubview(separator)
//        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8).isActive = true
//      }
//
//      stackView.addArrangedSubview(button)
//    }
//
//    addSubview(stackView)
//
//    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: stackView)
//    addConstraintsWithFormat(format: "V:|[v0(\(150.pixels))]|", views: stackView)
//  }
//}
