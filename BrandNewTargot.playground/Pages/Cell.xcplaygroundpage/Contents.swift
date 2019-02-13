//: [Previous](@previous)

import UIKit
import PlaygroundSupport

protocol ViewsConfigurable {
  func setupViews()
}

class BaseCustomCell: UICollectionViewCell, ViewsConfigurable {
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() { }
}

class CardCollectionCell: BaseCustomCell {

  static let width: CGFloat  = 1000.cgPixels
  static let height: CGFloat = 450.cgPixels

  let cellSize = CGSize(width: CardCollectionCell.width,
                        height: CardCollectionCell.height)

  var categoryBorder: UIView = {
    let catB = UIView()

    catB.backgroundColor = .red
//    catB.layer.masksToBounds = false

    return catB
  }()

  var nameLabel: UILabel = {
    let nameL = UILabel(frame: .zero)

    nameL.text = "PEPE"

    return nameL
  }()

  var addressLabel: UILabel = {
    let addressL = UILabel(frame: .zero)

    return addressL
  }()

  var phoneLabel: UILabel = {
    let phoneL = UILabel(frame: .zero)

    return phoneL
  }()

//  var starImage: UIImage = {
//    let starI = #imageLiteral(resourceName: "arrow_down")
//
//    return starI
//  }()
//
//  var starsLabel: UILabel = {
//    let starsL = UILabel(frame: .zero)
//
//    return starsL
//  }()
//
//  var pointImage: UIImage = {
//    let pointI = #imageLiteral(resourceName: "arrow_down")
//
//    return pointI
//  }()
//
//  var pointLabel: UILabel = {
//    let pointL = UILabel(frame: .zero)
//
//    return pointL
//  }()
//
//  var visitsImage: UIImage = {
//    let visitsI = #imageLiteral(resourceName: "arrow_down")
//
//    return visitsI
//  }()
//
//  var visitsLabel: UILabel = {
//    let visitsL = UILabel(frame: .zero)
//
//    return visitsL
//  }()
//
//  var petFriendly: UIImage = {
//    let petF = #imageLiteral(resourceName: "arrow_down")
//
//    return petF
//  }()

  lazy var labelsStack: UIStackView = {
    let labelsS = UIStackView(arrangedSubviews: [nameLabel])

    labelsS.alignment    = .leading
    labelsS.axis         = .vertical
    labelsS.distribution = .fillProportionally
    labelsS.spacing      = 10

    return labelsS
  }()

  override func setupViews() {

    self.layer.cornerRadius = 15.cgPixels
    backgroundColor = .white
//    clipsToBounds = true

    addSubview(categoryBorder)
    addSubview(labelsStack)

    addConstraintsWithFormat(format: "H:|[v0(\(32.pixels))]-\(70.pixels)-[v1]|", views: categoryBorder, labelsStack)

    addConstraintsWithFormat(format: "V:|[v0]|", views: categoryBorder)
  }
}

let view = CardCollectionCell(frame: CGRect(x: 0, y: 0, width: 1000.pixels, height: 450.pixels))

PlaygroundPage.current.liveView = view
//: [Next](@next)
