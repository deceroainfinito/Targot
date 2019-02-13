//
//  AddPhotoViewController.swift
//  Targot
//
//

import UIKit

import RxFlow
import RxSwift
import RxCocoa

import Photos

class AddPhotoViewController: UIViewController, ViewModelBased, Stepper {

  internal var picker     = UIImagePickerController()

  internal let geoService = GeolocationService()

  internal var disposeBag = DisposeBag()

  var presenter: PresenterDelegate!

  var viewModel: AddPhotoViewModel!

  var delegate: RecievesPhotoIds!

  internal var apP: AddPhotoPresenter {
    if let pres = presenter as? AddPhotoPresenter {
      return pres as AddPhotoPresenter
    } else {
      fatalError()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    picker.delegate = self
    presenter.setupViews()
    rxMagic()
  }

  fileprivate func rxMagic() {
    apP.libraryButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.selectImage()
    }).disposed(by: disposeBag)

    apP.cameraButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.takePhoto()
    }).disposed(by: disposeBag)

    apP.cancelButton.rx.tap.subscribe(onNext: { [unowned self] _ in
      self.step.accept(TargotSteps.dismissNewPhoto)
    }).disposed(by: disposeBag)
  }
}

extension AddPhotoViewController {

  func takePhoto() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.allowsEditing     = false
      picker.sourceType        = .camera
      picker.cameraCaptureMode = .photo
      picker.cameraDevice      = .rear

      present(picker, animated: true, completion: nil)
    } else {
      //TODO: fatalError description
      fatalError("No camera")
    }
  }

  func selectImage() {
    picker.sourceType    = .photoLibrary
    picker.allowsEditing = false

    present(picker, animated: true, completion: nil)
  }
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)


    defer {
      Debug.thisError(message: "Dismissing: \(#file)")
      dismiss(animated: true, completion: dismissBlock)
    }

    switch picker.sourceType {
    case .camera:
      guard let image = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) else {
        Debug.thisGuard(message: "No original photo: \(#file): \(dump(info))")
        return
      }
      guard let currentLocation = self.geoService.getCurrentLocation() else {
        Debug.thisGuard(message: "No current Location: \(#file)")
        break
      }

      SDPhotosHelper.addNewImage(image,
                                 withLocation: currentLocation,
                                 toAlbum: Constants.TargotAlbumName,
                                 onSuccess: { [unowned self] (placeholder) in
        self.viewModel.addPhoto(placeholder)
      }) { (error) in
        Debug.thisError(message: "No current Location: \(#file)")
        fatalError(error.debugDescription)
      }
    case .photoLibrary:
      fallthrough
    case .savedPhotosAlbum:
      guard let phAsset = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.phAsset)] as? PHAsset) else {
        Debug.thisGuard(message: "\(#file): \(info.debugDescription)")
        return
      }

      SDPhotosHelper.addExistingAsset(phAsset,
                                      toAlbum: Constants.TargotAlbumName,
                                      onSuccess: { (placeholder) in
        self.viewModel.addPhoto(placeholder)
      }) { (error) in
        Debug.thisError(message: error.debugDescription)
        //TODO: Update UI to post user?
        fatalError(error.debugDescription)
      }
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: dismissBlock)
  }

  func dismissBlock() {
    self.picker.delegate = nil
    self.delegate.getPhotoId(self.viewModel.photoId)
    self.step.accept(TargotSteps.dismissNewPhoto)
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
