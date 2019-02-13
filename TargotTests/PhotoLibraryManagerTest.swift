//
//  PhotoLibraryManagerTest.swift
//  TargotTests
//
//

import Photos
import XCTest
@testable import Targot


class MockPhotoLibray: PHPhotoLibrary {
  static var mockStatus: PHAuthorizationStatus!

  override static func authorizationStatus() -> PHAuthorizationStatus {
    return mockStatus
  }
}

class MockPhotoLibraryManager: PhotoLibraryManager { }

class PhotoLibraryManagerTest: XCTestCase {

  override func setUp() {
    super.setUp()

    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testCreateAlbum() {
    MockPhotoLibray.mockStatus = .authorized
    MockPhotoLibraryManager.photoLibrary = MockPhotoLibray.self

    XCTAssertTrue(MockPhotoLibraryManager.hasGrantedAccess)

    let deleteExpectation = expectation(description: "Delete Expectation.")

    MockPhotoLibraryManager.deleteTargotAlbum { (error) in
      XCTAssertEqual(error?.localizedDescription, PhotoLibraryManagerError.albumNotFound.localizedDescription)

      deleteExpectation.fulfill()
    }

    wait(for: [deleteExpectation], timeout: 5.0)

    let createExpectation = expectation(description: "Create Expectation.")
    MockPhotoLibraryManager.createTargotAlbum(completion: { (photoAlbum, error) in
      XCTAssertNotNil(photoAlbum)
      XCTAssertNil(error)

      createExpectation.fulfill()
    })

    wait(for: [createExpectation], timeout: 5.0)

    let delete2Expectation = expectation(description: "Delete Expectation 2")
    MockPhotoLibraryManager.deleteTargotAlbum { (error) in
      XCTAssertNil(error)

      delete2Expectation.fulfill()
    }

    wait(for: [delete2Expectation], timeout: 5.0)
  }

  func testDeleteError() {
    MockPhotoLibray.mockStatus = .authorized
    MockPhotoLibraryManager.photoLibrary = MockPhotoLibray.self

    XCTAssertTrue(MockPhotoLibraryManager.hasGrantedAccess)

    let createExpectation = expectation(description: "Create Expectation.")

    MockPhotoLibraryManager.createTargotAlbum(completion: { (photoAlbum, error) in
      print("Hurry!! Let the deletion ends in the simulator!")
      XCTAssertNotNil(photoAlbum)
      XCTAssertNil(error)

      createExpectation.fulfill()
    })

    wait(for: [createExpectation], timeout: 25.0)

  }
}
