//
//  AddPhotoViewModel.swift
//  Targot
//
//

import RxSwift

class AddPhotoViewModel {
  var photoId: String?

  init() { }

  func addPhoto(_ photo: String) {
    self.photoId = photo
  }
}
