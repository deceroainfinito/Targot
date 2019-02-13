//
//  UIExtensionsTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class UIExtensionsTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testConstraintsWithFormat() {
    let view = UIView()
    let innerView = UIView()

    view.addSubview(innerView)

    view.addConstraintsWithFormat(format: "H:|[v0]|", views: innerView)

    XCTAssertFalse(innerView.translatesAutoresizingMaskIntoConstraints)
    XCTAssertTrue(view.constraints.count > 0)
    XCTAssertTrue(view.constraints[0].isActive)
  }

  func testUIColor() {
    let whiteHex = try! UIColor.init(hex: 0xFFFFFF)
    let whiteRGB = UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)

    XCTAssertEqual(whiteHex.cgColor.components, whiteRGB.cgColor.components)

    XCTAssertThrowsError(try UIColor(red: -1, green: 0, blue: 0)) { error in
      XCTAssertEqual(error.localizedDescription, UIColorHexError.invalidRedValue.localizedDescription)
    }
    XCTAssertThrowsError(try UIColor(red: 256, green: 0, blue: 0)) { error in
      XCTAssertEqual(error.localizedDescription, UIColorHexError.invalidRedValue.localizedDescription)
    }
    XCTAssertThrowsError(try UIColor(red: 0, green: -23, blue: 0)) { error in
      XCTAssertEqual(error.localizedDescription, UIColorHexError.invalidGreenVaue.localizedDescription)
    }
    XCTAssertThrowsError(try UIColor(red: 0, green: 266, blue: 0)) { error in
      XCTAssertEqual(error.localizedDescription, UIColorHexError.invalidGreenVaue.localizedDescription)
    }
    XCTAssertThrowsError(try UIColor(red: 0, green: 0, blue: -3)) { error in
      XCTAssertEqual(error.localizedDescription, UIColorHexError.invalidBlueValue.localizedDescription)
    }
    XCTAssertThrowsError(try UIColor(red: 0, green: 0, blue: 333)) { error in
      XCTAssertEqual(error.localizedDescription, UIColorHexError.invalidBlueValue.localizedDescription)
    }

    XCTAssertNoThrow(try UIColor(red: 0, green: 0, blue: 0))
  }
}
