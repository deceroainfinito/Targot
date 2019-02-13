//
//  RealStorageTest.swift
//  TargotTests
//
//

import XCTest

import RealmSwift

@testable import Targot

class RealStorageTest: XCTestCase {

  var realmSM: RealmStorageManager!
  var aCard: Card!

  var defaultRealmConfig: Realm.Configuration!
  var incorrectRealmConfig: Realm.Configuration!

  override func setUp() {
    super.setUp()

    defaultRealmConfig           = Realm.Configuration.defaultConfiguration
    incorrectRealmConfig         = Realm.Configuration()
    incorrectRealmConfig.fileURL = URL(fileURLWithPath: "No way it may work!")

    try! realmSM = RealmStorageManager()

    let anAddress = Address(street: "Test St.", zipCode: "0", city: "Test City", country: "Test Country")
    aCard = Card(id: nil, name: "Test Card", date: Date(), address: anAddress, phoneNumber: "555 321 123", location: nil, visits: [], photos: [], notes: "Test note", category: .barest, socialNetworks: [:])
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testBadConfig() {
    XCTAssertThrowsError(try RealmStorageManager(configuration: incorrectRealmConfig)) { error in
      XCTAssertEqual(error.localizedDescription, RealmStorageManagerError.unsuccessfullInit.localizedDescription)
    }
  }

  func testProperCase() {
    XCTAssertNoThrow(try RealmStorageManager())

    XCTAssertNotNil(realmSM.realm)

    XCTAssertNoThrow(try realmSM.killThemAll())
    XCTAssertEqual(realmSM.fetchAllCards().count, 0)
    XCTAssertNil(realmSM.getCardById("NO CARD"))

    let cardId = try! realmSM.createCard(aCard)
    XCTAssertEqual(realmSM.fetchAllCards().count, 1)
    XCTAssertEqual(realmSM.getCardById(cardId)?.id, cardId)

    var savedCard = realmSM.getCardById(cardId)!

    savedCard.name = "PEPE LUIS"
    XCTAssertNoThrow(try realmSM.updateCard(savedCard))
    XCTAssertEqual(realmSM.getCardById(cardId)?.name, "PEPE LUIS")
  }

  func testUpdateCardExceptions() {
    XCTAssertThrowsError(try realmSM.updateCard(aCard)) { error  in
      XCTAssertEqual(error.localizedDescription, RealmStorageManagerError.noIdCantUpdateCard.localizedDescription)
    }

    aCard.id = "WRONG-ID"
    XCTAssertThrowsError(try realmSM.updateCard(aCard)) { error  in
      XCTAssertEqual(error.localizedDescription, RealmStorageManagerError.noCardCantUpdateCard.localizedDescription)
    }
  }
}
