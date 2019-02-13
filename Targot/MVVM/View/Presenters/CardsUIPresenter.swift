//
//  CardsUIPresenter.swift
//  Targot
//
//

import UIKit

class CardsUIPresenter: Presenter {

  // MARK: - CollectionView

  let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    let collView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    collView.register(CardCollectionCell.self, forCellWithReuseIdentifier: "CardCollectionCell")
    collView.backgroundColor = TargotColors.lightGrisete.color

    return collView
  }()

  let collectionViewBackground: UIView = {
    let backgroundView = UIView(frame: UIScreen.main.bounds)
    let emptyImage = UIImage(named: "cardholder")
    let emptyView = UIImageView(image: emptyImage)

    backgroundView.backgroundColor = TargotColors.lightGrisete.color
    emptyView.backgroundColor = TargotColors.lightGrisete.color

    backgroundView.addSubview(emptyView)

    emptyView.translatesAutoresizingMaskIntoConstraints = false

    emptyView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    emptyView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    emptyView.widthAnchor.constraint(equalToConstant: 120).isActive = true
    emptyView.heightAnchor.constraint(equalToConstant: 120).isActive = true

    return backgroundView
  }()

  // MARK: - Top bar

  lazy var titleView: UILabel = {
    let titleV             = UILabel(frame: CGRect(x: 0, y: 0, width: self.viewController.view.frame.width, height: 32))
    titleV.text            = NSLocalizedString("CardsTitle", comment: "")
    titleV.textColor       = UIColor.black
    titleV.font            = UIFont.systemFont(ofSize: 20)
    titleV.backgroundColor = UIColor.white
    titleV.alpha           = 1

    return titleV
  }()

  lazy var settingsBarButtonItem: UIBarButtonItem = {
    let settingsBBI = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: nil)
    settingsBBI.tintColor = .black

    return settingsBBI
  }()

  lazy var moreBarButtonItem: UIBarButtonItem = {
    let moreBBI = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: nil)
    moreBBI.tintColor = .black

    return moreBBI
  }()

  lazy var detailsBarButtonItem: UIBarButtonItem = {
    let detailsBBI = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: nil)
    detailsBBI.tintColor = .black

    return detailsBBI
  }()

  // MARK: - Setting up

  override func setupViews() {
    viewController.view.backgroundColor = TargotColors.lightGrisete.color

    collectionView.backgroundView = collectionViewBackground

    viewController.view.addSubview(collectionView)

    collectionView.anchor(top: viewController.view.safeAreaLayoutGuide.topAnchor,
                          leading: viewController.view.leadingAnchor,
                          bottom: viewController.view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: viewController.view.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 0, right: 0) )
  }
}
