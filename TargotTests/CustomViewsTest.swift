//
//  CustomViewsTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class CustomViewsTest: XCTestCase {

  var otherCGRect: CGRect!

  override func setUp() {
    super.setUp()

    otherCGRect  = CGRect(x: 0, y: 0, width: 100, height: 100)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLabel() {
    var label = Label(withText: "Label")

    XCTAssertEqual(label.frame, CGRect.zero)
    XCTAssertEqual(label.font, FontBuilder.noyhrBold.uiFont(size: FontBuilder.FontSize.label.cgPixels))
    XCTAssertEqual(label.text, "Label")
    XCTAssertEqual(label.textAlignment, .left)
    XCTAssertEqual(label.backgroundColor, TargotColors.lightGrisete.color)

    label = Label(frame: otherCGRect)
    XCTAssertEqual(label.frame, otherCGRect)

    //TODO: Swift 4.2 problem
//    let arcData = NSMutableData()
//    let arch    = try! NSKeyedUnarchiver.init(forReadingFrom: arcData as Data)
//    XCTAssertNotNil(Label(coder: arch!))
  }

  func testSeparator() {
    var separator = Separator(type: .up)
    XCTAssertEqual(separator.frame, .zero)
    XCTAssertEqual(separator.backgroundColor, TargotColors.borderUp.color)

    separator = Separator(type: .down)
    XCTAssertEqual(separator.frame, .zero)
    XCTAssertEqual(separator.backgroundColor, TargotColors.borderDown.color)

    separator = Separator(frame: otherCGRect)
    XCTAssertEqual(separator.frame, otherCGRect)

    //TODO: Swift 4.2 problem
//    let arcData = NSMutableData()
//    let arch    = try! NSKeyedUnarchiver.init(forReadingFrom: arcData as Data)
//    XCTAssertNotNil(Separator(coder: arch))
  }
}
