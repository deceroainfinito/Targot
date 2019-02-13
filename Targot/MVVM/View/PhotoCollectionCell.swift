//
//  PhotoCollectionCellCollectionViewCell.swift
//  Targot
//
//

import UIKit

import Photos

class PhotoCollectionCell: BaseCustomCell {

  let cellSize = CGSize(width: 300.cgPixels, height: 300.cgPixels)

  var identifier: String! {
    didSet {
      guard let asset: PHAsset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier],
                                                     options: nil).firstObject else { return }

      PHImageManager
        .default()
        .requestImage(for: asset,
                      targetSize: cellSize,
                      contentMode: .aspectFill,
                      options: nil) { [unowned self] (image, info) in
        self.photoView.image = image
      }
    }
  }

  var photoView: UIImageView = {
    let pv = UIImageView()

    pv.contentMode = .scaleToFill
    pv.clipsToBounds = true

    return pv
  }()

  override func setupViews() {
    addSubview(photoView)

    addConstraintsWithFormat(format: "H:|[v0(\(300.cgPixels))]|", views: photoView)
    addConstraintsWithFormat(format: "V:|[v0(\(300.cgPixels))]|", views: photoView)
  }
}
