//
//  PhotoLibraryManager.swift
//  Targot
//
//

import UIKit
import Photos
import CoreImage

protocol PhotoLibraryProtocol: class {
  static func authorizationStatus() -> PHAuthorizationStatus
}

extension PHPhotoLibrary: PhotoLibraryProtocol { }

enum PhotoLibraryManagerError: Error {
  case albumNotFound
  case albumNotCreated
  case assetNotFounded
  case changeRequestError
}

class PhotoLibraryManager {

  typealias PhotoAlbum = PHAssetCollection

  static var albumName: String = Constants.TargotAlbumName

  static var photoLibrary: PhotoLibraryProtocol.Type! = PHPhotoLibrary.self

  static var hasGrantedAccess: Bool {
    return photoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
  }

  static func createAlbum(withName name: String, completion: @escaping (PhotoAlbum?, Error?) -> ()) {
    let album = getAlbum(byName: name)

    if album != nil {
      completion(album, nil)
    } else {

      var newAlbumPlaceholder: PHObjectPlaceholder?

      PHPhotoLibrary.shared().performChanges({
        let newAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)

        newAlbumPlaceholder = newAlbumRequest.placeholderForCreatedAssetCollection
      }) { (didSuccess, error) in
        if error != nil {
          completion(nil, error)
        } else {
          guard let placeholder =
            newAlbumPlaceholder
            else { completion(nil,  PhotoLibraryManagerError.albumNotCreated); return }
          guard let createdAlbum =
            PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil).firstObject
            else { completion(nil, PhotoLibraryManagerError.albumNotCreated); return }

          completion(createdAlbum, nil)
        }
      }
    }
  }

  static func createTargotAlbum(completion: @escaping (PhotoAlbum?, Error?) -> ()) {
    createAlbum(withName: PhotoLibraryManager.albumName, completion: completion)
  }

  static func deleteAlbum(byName name: String, completion: @escaping(Error?) -> ()) {
    let album = getAlbum(byName: name)

    if album == nil {
      completion(PhotoLibraryManagerError.albumNotFound)
    } else {
      PHPhotoLibrary.shared().performChanges({
        PHAssetCollectionChangeRequest.deleteAssetCollections([album!] as NSArray)
      }) { (didSuccess, error) in
        if didSuccess {
          completion(nil)
        } else {
          completion(error)
        }
      }
    }
  }

  static func deleteTargotAlbum(completion: @escaping(Error?) -> ()) {
    deleteAlbum(byName: PhotoLibraryManager.albumName, completion: completion)
  }


  static func addNewImage(_ image: UIImage,
                          withLocation location: (latitude: Double, longitude: Double)?,
                          toAlbum albumName: String = Constants.TargotAlbumName,
                          onSuccess success: @escaping(String) -> (),
                          inFailure failure: @escaping(Error?) -> ()) {

    guard let photoAlbum = getAlbum(byName: albumName) else {
      failure(PhotoLibraryManagerError.albumNotFound)
      return
    }

    var localIdentifier: String!

    PHPhotoLibrary.shared().performChanges({
      let albumRequest = PHAssetCollectionChangeRequest(for: photoAlbum)
      let assetCreationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)

      if let location = location {
        assetCreationRequest.location = CLLocation(latitude: location.latitude, longitude: location.longitude)
      }
      assetCreationRequest.creationDate = Date()

      let placeholder = assetCreationRequest.placeholderForCreatedAsset

      if placeholder != nil {
        albumRequest?.addAssets([placeholder!] as NSArray)
        localIdentifier = (placeholder?.localIdentifier)!
      }
    }) { (didSucceed, error) in

    }


  }



  fileprivate static func getAlbum(byName name: String) -> PHAssetCollection? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", name)
    guard let album =
      PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions).firstObject
      else { return nil }

    return album
  }
}
