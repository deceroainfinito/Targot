//
//  RealmAddress.swift
//  Targot
//
//

import Foundation

import RealmSwift

class RealmAddress: IdObject {

  @objc dynamic var street: String?  = nil
  @objc dynamic var zipCode: String? = nil
  @objc dynamic var city: String?    = nil
  @objc dynamic var country: String? = nil

  var addressStruct: Address {
    let address = Address(street: self.street, zipCode: self.zipCode, city: self.city, country: self.country)

    return address
  }

  let cards = LinkingObjects(fromType: RealmCard.self, property: "address")
  var card: RealmCard {
    return self.cards.first!
  }

  convenience init(address: Address) {
    self.init()

    self.street  = address.street
    self.zipCode = address.zipCode
    self.city    = address.city
    self.country = address.country
  }

  override static func indexedProperties() -> [String] {
    return ["zipCode", "city"]
  }
}
