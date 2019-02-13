//
//  SDPhotosHelper.swift
//  SDPhotosHelper
//
//  Created by Sagar Dagdu on 8/4/17.
//  Copyright © 2017 Sagar Dagdu. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import Photos
import CoreImage

public class SDPhotosHelper: NSObject {

  // MARK: - Constants

  static let assetNotFoundError : NSError = NSError(domain: "SDPhotosHelper", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Asset with given identifier not found"])
  static let assetCreationFailure = NSError(domain: "SDPhotosHelper", code: 1002, userInfo: [NSLocalizedDescriptionKey : "Asset could not be added from the given source"])
  static let albumNotFoundError : NSError = NSError(domain: "SDPhotosHelper", code: 1003, userInfo: [NSLocalizedDescriptionKey : "Album with given name was not found"])
  static let changeRequestError : NSError = NSError(domain: "SDPhotosHelper", code: 1004, userInfo: [NSLocalizedDescriptionKey : "Change request fails somehow"])


  static var photoLibrary: PhotoLibraryProtocol.Type! = PHPhotoLibrary.self

  static var hasGrantedAccess: Bool {

    return photoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
  }

  // MARK: - Methods

  public static func askForPermission(onResult result:@escaping() -> Void) {

    if !hasGrantedAccess {
      PHPhotoLibrary.requestAuthorization { (status) in
        result()
      }
    }
  }

  public static func createAlbum(withTitle title:String, onResult result:@escaping(Bool,Error?) -> Void) {

    guard self.getAlbum(withName: title) == nil else {
      result(true,nil)
      return
    }
    PHPhotoLibrary.shared().performChanges({
      PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
    }) { (didSucceed, error) in
      OperationQueue.main.addOperation({
        didSucceed ? result(didSucceed,nil) : result(false, error)
      })
    }
  }

  // MARK: - Image Utilities

  public static func addExistingAsset(_ asset: PHAsset,
                                      toAlbum albumName: String,
                                      onSuccess success:@escaping(String) -> Void,
                                      onFailure failure:@escaping(Error?) -> Void) {

    let options   = PHFetchOptions()
    let predicate = NSPredicate(format: "localizedTitle = %@", Constants.TargotAlbumName)
    options.predicate = predicate

    PHPhotoLibrary.shared().performChanges({
      guard let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: options).firstObject else { failure(SDPhotosHelper.albumNotFoundError); return }
      guard let collectionChangeRequest = PHAssetCollectionChangeRequest(for: album) else { failure(SDPhotosHelper.changeRequestError); return }

      collectionChangeRequest.addAssets([asset] as NSArray)
    }) { (didSucceed, error) in
      didSucceed ? success(asset.localIdentifier) : failure(error)
    }
  }

  public static func addNewImage(_ image:UIImage,
                                 withLocation location: (latitude: Double, longitude: Double)?,
                                 toAlbum albumName:String,
                                 onSuccess success:@escaping(String) -> Void,
                                 onFailure failure:@escaping(Error?) -> Void) {

    guard let album = self.getAlbum(withName: albumName) else {
      Debug.thisGuard(message: "Algum not found: \(#file)")
      return
    }

    var localIdentifier = String()

    PHPhotoLibrary.shared().performChanges({
      let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
      let assetCreationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)

      if let location = location {
        assetCreationRequest.location = CLLocation(latitude: location.latitude, longitude: location.longitude)
      }
      assetCreationRequest.creationDate = Date()
      let placeHolder = assetCreationRequest.placeholderForCreatedAsset

      albumChangeRequest?.addAssets([placeHolder!] as NSArray)
      if placeHolder != nil {
        localIdentifier = (placeHolder?.localIdentifier)!
      }
    }) { (didSucceed, error) in
      OperationQueue.main.addOperation({

        if didSucceed {
          if location == nil {
            Debug.thisDebug(message: "No location for image: \(localIdentifier)")
          }
          success(localIdentifier)
        } else {
          Debug.thisError(message: error.debugDescription)
        }
      })
    }
  }

  public static func getImage(withIdentifier identifier:String,
                              fromAlbum album:String,
                              onSuccess success:@escaping(UIImage?) -> Void,
                              onFailure failure:@escaping(Error?) -> Void) {

    if let asset = self.getAsset(fromAlbum: album, withLocalIdentifier: identifier) {
      let imageManager = PHImageManager.default()
      imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, _) in
        OperationQueue.main.addOperation({
          success(image)
        })
      }
    } else {
      OperationQueue.main.addOperation({
        failure(SDPhotosHelper.assetNotFoundError)
      })
    }
  }

  public static func getImages(fromAlbum album:String,
                               onSuccess success:@escaping([UIImage]) -> Void,
                               onFailure failure:@escaping(Error?) -> Void) {

    guard let album = self.getAlbum(withName: album) else {
      failure(SDPhotosHelper.albumNotFoundError)
      return
    }
    let optionsOrderImage  = PHFetchOptions()
    optionsOrderImage.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]

    let photos = PHAsset.fetchAssets(in: album, options: optionsOrderImage)
    var images : [UIImage] = []

    photos.enumerateObjects(_:) { (asset, _, _) in
      let image = SDPhotosHelper.getImageFromAsset(asset)
      images.append(image)
    }
    OperationQueue.main.addOperation({
      success(images)
    })
  }

  public static func deleteImage(withIdentifier identifier:String,
                                 fromAlbum album:String,
                                 onSuccess success:@escaping(Bool) -> Void,
                                 onFailure failure:@escaping(Error?) -> Void) {
    var deleted = false
    if let fetchresult = self.getAssetFetchResult(fromAlbum: album, withLocalIdentifier: identifier) {

      PHPhotoLibrary.shared().performChanges({
        if let album = getAlbum(withName: album) {
          let request = PHAssetCollectionChangeRequest(for: album, assets: fetchresult)
          if let asset = fetchresult.firstObject {
            let fastEnumeration : NSArray = [asset] as NSArray
            request?.removeAssets(fastEnumeration)
            deleted = true
          } else {
            failure(SDPhotosHelper.assetNotFoundError)
          }
        } else {
          failure(SDPhotosHelper.albumNotFoundError)
        }
      }, completionHandler: { (didSucceed, error) in

        OperationQueue.main.addOperation({
          didSucceed ? success(deleted) : failure(error)
        })

      })
    } else {
      OperationQueue.main.addOperation({
        failure(SDPhotosHelper.assetNotFoundError)
      })
    }
  }

  // MARK: - Private helper methods

  fileprivate static func getImageFromAsset(_ asset: PHAsset) -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var image = UIImage()
    option.isSynchronous = true

    manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, _) -> Void in
      image = result!
    })
    return image
  }


  fileprivate static func getAsset(fromAlbum album:String,
                                   withLocalIdentifier localIdentifier:String) -> PHAsset? {

    /*The below code is commented due to a bug from Apple :
     https://forums.developer.apple.com/thread/17498
     let fetchOptions = PHFetchOptions()
     fetchOptions.predicate = NSPredicate(format: "title = %@", album)
     */
    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier],
                                          options: nil)

    return fetchResult.count > 0 ? fetchResult.firstObject : nil
  }

  fileprivate static func getAssetFetchResult(fromAlbum album:String,
                                              withLocalIdentifier localIdentifier:String) -> PHFetchResult<PHAsset>? {

    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier],
                                          options: nil)

    return fetchResult
  }

  fileprivate static func getAlbum(withName name:String) -> PHAssetCollection? {

    let assetCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
    guard assetCollection.count > 0 else { return nil }

    var desiredAlbum:PHAssetCollection? = nil
    
    assetCollection.enumerateObjects({ (assetCollection, _, stop) in
      if let album  = assetCollection as PHAssetCollection? {
        if album.localizedTitle == name {
          desiredAlbum = album
          stop.pointee = true
        }
      }
    })
    return desiredAlbum
  }
}
