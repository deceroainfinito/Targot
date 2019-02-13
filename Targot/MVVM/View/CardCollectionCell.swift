//
//  CardCollectionCell.swift
//  Targot
//
//

import UIKit
import RxSwift
import RxCocoa

class CardCollectionCell: BaseCustomCell {

  // MARK: - Rx Setup
  fileprivate var disposeBag = DisposeBag()

  weak var viewModel: CardCellViewModel? {
    didSet {
      setupBindings()
      setupCellColor()
    }
  }

  func setupCellColor() {
    guard let viewModel = viewModel else { return }

    backgroundColor       = TargotColors.byCategory(viewModel.categoryValue)
    starsImage.tintColor  = TargotColors.byCategory(viewModel.categoryValue)
    pointImage.tintColor  = TargotColors.byCategory(viewModel.categoryValue)
    visitsImage.tintColor = TargotColors.byCategory(viewModel.categoryValue)
  }

  func setupBindings() {
    guard let viewModel = viewModel else { return }

    viewModel.name.asObservable().bind(to: nameLabel.rx.text).disposed(by: disposeBag)
    viewModel.address.asObservable().bind(to: addressLabel.rx.text).disposed(by: disposeBag)
    viewModel.phone.asObservable().bind(to: phoneLabel.rx.text).disposed(by: disposeBag)
    viewModel.stars.asObservable().bind(to: starsLabel.rx.text).disposed(by: disposeBag)
    viewModel.distance.asObservable().bind(to: pointLabel.rx.text).disposed(by: disposeBag)
    viewModel.visits.asObservable().bind(to: visitsLabel.rx.text).disposed(by: disposeBag)

    viewModel.category.asObservable().subscribe(onNext: { [unowned self] (category) in
      guard let category = category, let categoryValue = CategoryValue(rawValue: category) else {
        print("No category to reload the cell")
        return
      }

      self.backgroundColor = TargotColors.byCategory(categoryValue)
    }).disposed(by: disposeBag)

    let tapGesture = UITapGestureRecognizer()
    phoneLabel.addGestureRecognizer(tapGesture)

    tapGesture.rx.event.bind { (recognizer) in
      do {
        try PhoneDialer(application: UIApplication.shared).callPhoneNumer(viewModel.card.phoneNumber)
      } catch {
        Debug.thisThrows(message: error.localizedDescription)
      }
    }.disposed(by: disposeBag)
  }

  // MARK: - View setup
  static let width: CGFloat  = UIScreen.mainWidth - 70.cgPixels
  static let height: CGFloat = 530.cgPixels

  let cellSize = CGSize(width: CardCollectionCell.width,
                        height: CardCollectionCell.height)

  var mainBackground: UIView = {
    let mainB = UIView(frame: .zero)

    mainB.backgroundColor = .white
    mainB.translatesAutoresizingMaskIntoConstraints = false

    return mainB
  }()

  var nameLabel: UILabel = {
    let nameL = UILabel(frame: .zero)

    nameL.backgroundColor           = .white
    nameL.font                      = FontBuilder.abulaBold.uiFont(size: 24)
    nameL.numberOfLines             = 2
    nameL.adjustsFontSizeToFitWidth = true

    return nameL
  }()

  var addressLabel: UILabel = {
    let addressL = UILabel(frame: .zero)

    addressL.backgroundColor           = .white
    addressL.font                      = FontBuilder.noyhRMedium.uiFont(size: 20)
    addressL.textColor                 = UIColor.gray
    addressL.numberOfLines             = 2
    addressL.adjustsFontSizeToFitWidth = true

    return addressL
  }()

  var phoneLabel: UILabel = {
    let phoneL = UILabel(frame: .zero)

    phoneL.backgroundColor = .white
    phoneL.font            = FontBuilder.noyhRMedium.uiFont(size: 20)
    phoneL.textColor       = UIColor.black
    phoneL.numberOfLines   = 1
    phoneL.isUserInteractionEnabled = true

    return phoneL
  }()

  var starsImage: UIImageView = {
    let image = #imageLiteral(resourceName: "icon_star").withRenderingMode(.alwaysTemplate)
    let starI = UIImageView(image: image)

    starI.backgroundColor = .white
    starI.contentMode     = .scaleAspectFit

    return starI
  }()

  var starsLabel: UILabel = {
    let starsL = UILabel(frame: .zero)

    starsL.backgroundColor = .white
    starsL.font            = FontBuilder.noyhRLight.uiFont(size: 18)
    starsL.textColor       = UIColor.darkGray
    starsL.numberOfLines   = 1

    return starsL
  }()


  var pointImage: UIImageView = {
    let image  = #imageLiteral(resourceName: "icon_map").withRenderingMode(.alwaysTemplate)
    let pointI = UIImageView(image: image)

    pointI.backgroundColor = .white
    pointI.tintColor       = UIColor.blue
    pointI.contentMode     = .scaleAspectFit

    return pointI
  }()

  var pointLabel: UILabel = {
    let pointL = UILabel(frame: .zero)

    pointL.backgroundColor = .white
    pointL.font            = FontBuilder.noyhRLight.uiFont(size: 18)
    pointL.textColor       = UIColor.darkGray
    pointL.numberOfLines   = 1

    return pointL
  }()

  var visitsImage: UIImageView = {
    let image  = #imageLiteral(resourceName: "icon_eye").withRenderingMode(.alwaysTemplate)
    let visitI = UIImageView(frame: .zero)

    visitI.image           = image
    visitI.backgroundColor = .white
    visitI.tintColor       = .green
    visitI.contentMode     = .scaleAspectFit

    return visitI
  }()

  var visitsLabel: UILabel = {
    let visitL = UILabel(frame: .zero)

    visitL.backgroundColor = .white
    visitL.font            = FontBuilder.noyhRLight.uiFont(size: 18)
    visitL.textColor       = UIColor.darkGray
    visitL.numberOfLines   = 1

    return visitL
  }()

  // MARK: - Layout setup

  override func setupViews() {

    self.layer.cornerRadius = 15.cgPixels
    backgroundColor = .red
    clipsToBounds = true

    addSubview(mainBackground)

    mainBackground.anchor(top: self.topAnchor,
                          leading: self.leadingAnchor,
                          bottom: self.bottomAnchor,
                          trailing: self.trailingAnchor,
                          padding: .init(top: 0, left: 42.cgPixels, bottom: 0, right: 0))

    [nameLabel,
     addressLabel,
     phoneLabel,
     starsImage,
     starsLabel,
     pointImage,
     pointLabel,
     visitsImage,
     visitsLabel].forEach { mainBackground.addSubview($0) }

    nameLabel.anchor(top: mainBackground.topAnchor,
                     leading: mainBackground.leadingAnchor,
                     bottom: nil,
                     trailing: mainBackground.trailingAnchor,
                     padding: .init(top: 42.cgPixels, left: 42.cgPixels, bottom: 0, right: 12.cgPixels))

    addressLabel.anchor(top: nameLabel.bottomAnchor,
                        leading: mainBackground.leadingAnchor,
                        bottom: nil,
                        trailing: mainBackground.trailingAnchor,
                        padding: .init(top: 12.cgPixels, left: 42.cgPixels, bottom: 0, right: 12.cgPixels))

    phoneLabel.anchor(top: addressLabel.bottomAnchor,
                      leading: mainBackground.leadingAnchor,
                      bottom: nil,
                      trailing: mainBackground.trailingAnchor,
                      padding: .init(top: 12.cgPixels, left: 42.cgPixels, bottom: 0, right: 12.cgPixels))

    starsImage.anchor(top: nil,
                      leading: mainBackground.leadingAnchor,
                      bottom: mainBackground.bottomAnchor,
                      trailing: nil,
                      padding: .init(top: 0, left: 42.cgPixels, bottom: 62.cgPixels, right: 0),
                      size: .init(width: 40.cgPixels, height: 40.cgPixels))

    starsLabel.anchor(top: nil,
                      leading: starsImage.trailingAnchor,
                      bottom: mainBackground.bottomAnchor,
                      trailing: nil,
                      padding: .init(top: 0, left: 10.cgPixels, bottom: 42.cgPixels, right: 0))

    pointImage.anchor(top: nil,
                      leading: starsLabel.trailingAnchor,
                      bottom: mainBackground.bottomAnchor,
                      trailing: nil,
                      padding: .init(top: 0, left: 20.cgPixels, bottom: 62.cgPixels, right: 0),
                      size: .init(width: 40.cgPixels, height: 40.cgPixels))

    pointLabel.anchor(top: nil,
                      leading: pointImage.trailingAnchor,
                      bottom: mainBackground.bottomAnchor,
                      trailing: nil,
                      padding: .init(top: 0, left: 10.cgPixels, bottom: 42.cgPixels, right: 0))

    visitsImage.anchor(top: nil,
                       leading: pointLabel.trailingAnchor,
                       bottom: mainBackground.bottomAnchor,
                       trailing: nil,
                       padding: .init(top: 0, left: 20.cgPixels, bottom: 62.cgPixels, right: 0),
                       size: .init(width: 40.cgPixels, height: 40.cgPixels))

    visitsLabel.anchor(top: nil,
                       leading: visitsImage.trailingAnchor,
                       bottom: mainBackground.bottomAnchor,
                       trailing: nil,
                       padding: .init(top: 0, left: 10.cgPixels, bottom: 42.cgPixels, right: 0))

  }
}
