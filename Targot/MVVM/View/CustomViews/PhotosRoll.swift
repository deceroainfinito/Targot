//
//  PhotosRoll.swift
//  Targot
//
//

import UIKit

class PhotosRollLayout: UICollectionViewLayout { }

class PhotosRoll: UIView {

  var addNewPhotoButton: UIButton = {
    let addButton = UIButton(frame: .zero)

    addButton.setImage(#imageLiteral(resourceName: "icon_photos"), for: .normal)

    return addButton
  }()

  var photosCollection: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(width: 300.cgPixels, height: 300.cgPixels)

    let pc = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    pc.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: "PhotoCollectionCell")
    pc.backgroundColor = TargotColors.lightGrisete.color

    return pc
  }()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init() {
    self.init(frame: .zero)

    setupViews()
  }

  func setupViews() {
    addSubview(addNewPhotoButton)
    addSubview(photosCollection)

    addConstraintsWithFormat(format: "H:|-(\(40.cgPixels))-[v0(\(300.cgPixels))]-\(30.cgPixels)-[v1]|", views: addNewPhotoButton, photosCollection)
    addConstraintsWithFormat(format: "V:|[v0(\(300.cgPixels))]|", views: addNewPhotoButton)

    addConstraint(NSLayoutConstraint(item: photosCollection,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: addNewPhotoButton,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: 0))
    
    addConstraint(NSLayoutConstraint(item: photosCollection,
                                     attribute: .height,
                                     relatedBy: .equal,
                                     toItem: addNewPhotoButton,
                                     attribute: .height,
                                     multiplier: 1,
                                     constant: 0))
  }
}
