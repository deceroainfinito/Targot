//
//  PhoneDialerTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

struct MockOpener: URLOpenerProtocol {
  func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
    if canOpen {
      completion?(true)
    }
  }

  var canOpen: Bool

  func canOpenURL(_ url: URL) -> Bool {
    return canOpen
  }
}

class PhoneDialerTest: XCTestCase {

  func testInit() {

    XCTAssertThrowsError(try PhoneDialer(application: MockOpener(canOpen: true)).callPhoneNumer("")) { error in
      XCTAssertEqual(error.localizedDescription, PhoneDialer.PhoneDialerError.incorrectOrEmptyNumber.localizedDescription)
    }

    XCTAssertThrowsError(try PhoneDialer(application: MockOpener(canOpen: false)).callPhoneNumer("1004")) { error in
      XCTAssertEqual(error.localizedDescription, PhoneDialer.PhoneDialerError.noSuitableUIApplication.localizedDescription)
    }

    XCTAssertNoThrow(try PhoneDialer(application: MockOpener(canOpen: true)).callPhoneNumer("1004"))
  }
}
