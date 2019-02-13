//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport

let fontURL = Bundle.main.url(forResource: "NoyhR-Bold", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
let font = UIFont(name: "NoyhR-Bold", size: 48.pointsToPixels())!

let fontURL2 = Bundle.main.url(forResource: "Abula-Bold", withExtension: "otf")
CTFontManagerRegisterFontsForURL(fontURL2! as CFURL, CTFontManagerScope.process, nil)
let font2 = UIFont(name: "Abula-Bold", size: 102.pointsToPixels())!

let fontURL3 = Bundle.main.url(forResource: "NoyhR-Medium", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL2! as CFURL, CTFontManagerScope.process, nil)

public class TargotCategoryView: UIView {

  var stackView: UIStackView = {
    let sView = UIStackView()

    sView.axis = .horizontal
    sView.distribution = .equalCentering
    sView.alignment = .center

    return sView
  }()

  class CategorySeparatorView: UIView {

    let darkStripeColor  = UIColor(hex: 0x7B8E9F)
    let lightStripeColor = UIColor(hex: 0xFEFFFF)

    let darkStripeWidth  = 1
    let lightStripeWidth = 1

    let darkStripeHeight  = 1
    let lightStripeHeight = 1

    override func draw(_ rect: CGRect) {
      let patternWidth  = darkStripeWidth + lightStripeWidth
      let patternHeight = min(darkStripeHeight, lightStripeHeight)

      let patternSize = CGSize(width: patternWidth, height: patternHeight)

      let context = UIGraphicsGetCurrentContext()

      UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0)

      let darkStripePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: darkStripeWidth, height: darkStripeHeight))
      darkStripeColor.setFill()
      darkStripePath.fill()

      let lightStripePath =
        UIBezierPath(rect: CGRect(x: darkStripeWidth, y: 0, width: lightStripeWidth, height: lightStripeHeight))
      lightStripeColor.setFill()
      lightStripePath.fill()

      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      UIColor(patternImage: image!).setFill()

      context?.fill(rect)
    }
  }

  var categories: [UIButton] = {
    var buttons: [UIButton] = []

    let shoppingButton = UIButton(frame: .zero)
    let tienda = UIImage(named: "categorias_color_tienda.pdf")
    shoppingButton.setImage(tienda, for: .normal)
    shoppingButton.tag = 0

    let deporte = UIImage(named: "categorias_color_deport.pdf")
    let sportButton = UIButton(frame: .zero)
    sportButton.setImage(deporte, for: .normal)
    sportButton.tag = 1

    let ocio = UIImage(named: "categorias_color_ocio.pdf")
    let leisureButton = UIButton(frame: .zero)
    leisureButton.setImage(ocio, for: .normal)
    leisureButton.tag = 2

    let brImage = UIImage(named: "categorias_color_b_r.pdf")
    let brButton = UIButton(frame: .zero)
    brButton.setImage(brImage, for: .normal)
    brButton.tag = 3

    buttons.append(shoppingButton)
    buttons.append(sportButton)
    buttons.append(leisureButton)
    buttons.append(brButton)

    return buttons
  }()

  let vSeparator: UIView = {
    let vSprt = UIView()

    vSprt.backgroundColor = TargotColors.borderUp.color

    vSprt.addConstraint(NSLayoutConstraint(item: vSprt,
                                        attribute: NSLayoutAttribute.width,
                                        relatedBy: .equal,
                                        toItem: vs,
                                        attribute: NSLayoutAttribute.width,
                                        multiplier: 1,
                                        constant: 0))

    return vs
  }()

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  func setupViews() {
    categories.forEach { (button) in
      if stackView.arrangedSubviews.count > 0 {

        let separator = CategorySeparatorView()
        separator.widthAnchor.constraint(equalToConstant: 2).isActive = true

        stackView.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8).isActive = true
      }

      stackView.addArrangedSubview(button)
    }

    addSubview(stackView)

    addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: stackView)
    addConstraintsWithFormat(format: "V:|[v0(\(150.pixels))]|", views: stackView)
  }
}

let uiview = UIViewController()

let scrollView: UIScrollView = {
  let sView = UIScrollView(frame: CGRect.zero)

  sView.flashScrollIndicators()
  sView.scrollsToTop = true
  sView.alwaysBounceHorizontal = false
  sView.alwaysBounceVertical   = false

  sView.backgroundColor = TargotColors.lightGrisete.color

  return sv
}()

let mainContent: UIView = {
  let mainC = UIView(frame: CGRect.zero)

  mainC.backgroundColor = TargotColors.lightGrisete.color

  return mainC
}()

let nameLabel: UILabel = {
  let nameL = UILabel()

  nameL.font = UIFont(name: FontClassName.NoyhrBold.rawValue, size: 48.pointsToPixels())
  nameL.text = "NAME"
  nameL.textAlignment = .left

  nameL.backgroundColor = TargotColors.lightGrisete.color

  return nameL
}()

let nameField: TargotSeparatedTextField = TargotSeparatedTextField(frame: .zero)

let categories = TargotCategoryView()

uiview.view.addSubview(scrollView)

uiview.view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
uiview.view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)

scrollView.addSubview(mainContent)
scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: mainContent)
scrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: mainContent)

mainContent.addSubview(nameLabel)
mainContent.addSubview(nameField)
mainContent.addSubview(categories)

mainContent.addConstraintsWithFormat(format: "H:|-\(40.cgPixels)-[v0(\(UIScreen.main.bounds.width - 40.cgPixels))]|",
  views: nameLabel)
mainContent.addConstraintsWithFormat(format: "H:|[v0(\(UIScreen.main.bounds.width))]|", views: nameField)
mainContent.addConstraintsWithFormat(format: "V:|-8-[v0(24)]-0-[v1]-8-[v2]|", views: nameLabel, nameField, categories)

PlaygroundPage.current.liveView = uiview

//: [Next](@next)
