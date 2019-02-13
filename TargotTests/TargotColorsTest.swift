//
//  TargotColors.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class TargotColorsTest: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testHexValues() {
    XCTAssertEqual(TargotColors.hexValues, [0x5789fa,
                                            0x28ceba,
                                            0xad5cff,
                                            0xfb7c91,
                                            0xfeaa4f,
                                            0xefeff4,
                                            0xa0a1a1,
                                            0x555555,
                                            0xEBF0F3,
                                            0xE0E5E9,
                                            0xE4E5E8])
  }

  func testCGColor() {
    XCTAssertEqual(TargotColors.azulete.cgColor, try! UIColor.init(hex: TargotColors.hexValues[0]).cgColor)
  }

  func testByCategory() {
    XCTAssertEqual(TargotColors.byCategory(CategoryValue.none), TargotColors.griseteIcons.color)
    XCTAssertEqual(TargotColors.byCategory(CategoryValue.shopping), TargotColors.moradete.color)
    XCTAssertEqual(TargotColors.byCategory(CategoryValue.sport), TargotColors.naranjete.color)
    XCTAssertEqual(TargotColors.byCategory(CategoryValue.leisure), TargotColors.rosete.color)
    XCTAssertEqual(TargotColors.byCategory(CategoryValue.barest), TargotColors.verdete.color)
  }
}
