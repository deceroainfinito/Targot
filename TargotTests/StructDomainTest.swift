//
//  StructDomainTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class StructDomainTest: XCTestCase {

  var card: Card!
  var commonDate: Date!
  var sharedAddress: Address!

  override func setUp() {
    super.setUp()

    commonDate = Date()

    sharedAddress = Address(street: "Sesame St. 1", zipCode: "0123", city: "", country: "Unkwoned")

    card = Card(id: "0123",
                name: "Pepe Luis",
                date: commonDate,
                address: nil,
                phoneNumber: nil,
                location: nil,
                visits: [],
                photos: [],
                notes: nil,
                category: CategoryValue.barest,
                socialNetworks: [:])

    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testCardInit() {

    XCTAssertEqual("0123", card.id)
    XCTAssertEqual("Pepe Luis", card.name)
    XCTAssertEqual(commonDate, card.date)
    XCTAssertNil(card.address, "No address")
    XCTAssertNil(card.phoneNumber, "No address")
    XCTAssertNil(card.location, "No location")
    XCTAssertNil(card.notes, "No notes")

    XCTAssertEqual(card.category, CategoryValue.barest)
    XCTAssertEqual(card.visits.count, 0)
    XCTAssertEqual(card.photos.count, 0)
    XCTAssertEqual(card.socialNetworks.count, 0)
  }

  func testCompleteAddress() {
    XCTAssertEqual(sharedAddress.completeAddress, "Sesame St. 1, 0123")
  }

  func testCategory() {
    let catBarest = Category.bars
    XCTAssertEqual(catBarest.description, NSLocalizedString("CategoryBars", comment: ""))
    let catLeisure = Category.leisure
    XCTAssertEqual(catLeisure.description, NSLocalizedString("CategoryLeisure", comment: ""))
    let catSports = Category.sports
    XCTAssertEqual(catSports.description, NSLocalizedString("CategorySports", comment: ""))
    let catCulture = Category.culture
    XCTAssertEqual(catCulture.description, NSLocalizedString("CategoryCulture", comment: ""))
  }
}
