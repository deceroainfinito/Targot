//
//  OwnExtensionsTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class OwnExtensionsTest: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testExample() {
    var string = "1234567890"

    XCTAssertEqual("12 34 56 78 90", string.splitBy(" ", each: 2))

    string.splitedBy(" ", each: 2)
    XCTAssertEqual("12 34 56 78 90", string)
  }
}
