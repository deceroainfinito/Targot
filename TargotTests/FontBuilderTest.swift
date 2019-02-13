//
//  FontBuilderTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class FontBuilderTest: XCTestCase {

  var mainScreenScale: CGFloat!

  override func setUp() {
    super.setUp()

    mainScreenScale = UIScreen.main.scale
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPointsToPixels() {

    XCTAssertEqual(mainScreenScale, 3)
    XCTAssertEqual(10.pointsToPixels(), 4.0)
    XCTAssertEqual(-10.pointsToPixels(), -4.0)
  }

  func testFontSize() {
    XCTAssertEqual(mainScreenScale, 3)
    XCTAssertEqual(FontBuilder.FontSize.bigField.cgPixels, 28.0)
    XCTAssertEqual(FontBuilder.FontSize.label.cgPixels, 18.0)
  }

  func testFontBuilder() {

    XCTAssertEqual(FontBuilder.FontSize.bigField.cgPixels, 84 / mainScreenScale)
    XCTAssertEqual(FontBuilder.FontSize.label.cgPixels, 54 / mainScreenScale)

    var url = FontBuilder.abulaBold.fontURL
    XCTAssertEqual(url?.lastPathComponent,
                   "\(FontBuilder.FontName.abulaBold.rawValue).\(FontBuilder.FontExt.otf.rawValue)")

    url = FontBuilder.noyhRLight.fontURL
    XCTAssertEqual(url?.lastPathComponent,
                   "\(FontBuilder.FontName.noyhRLight.rawValue).\(FontBuilder.FontExt.ttf.rawValue)")

    url = FontBuilder.noyhRRegular.fontURL
    XCTAssertEqual(url?.lastPathComponent,
                   "\(FontBuilder.FontName.noyhRRegular.rawValue).\(FontBuilder.FontExt.ttf.rawValue)")

    url = FontBuilder.noyhrBold.fontURL
    XCTAssertEqual(url?.lastPathComponent,
                   "\(FontBuilder.FontName.noyhrBold.rawValue).\(FontBuilder.FontExt.ttf.rawValue)")

    url = FontBuilder.noyhRMedium.fontURL
    XCTAssertEqual(url?.lastPathComponent,
                   "\(FontBuilder.FontName.noyhRMedium.rawValue).\(FontBuilder.FontExt.ttf.rawValue)")

  }
}
