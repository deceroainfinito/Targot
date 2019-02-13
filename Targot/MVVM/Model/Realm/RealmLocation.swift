//
//  RealmLocation.swift
//  Targot
//
//

import Foundation

import RealmSwift

class RealmLocation: IdObject {
  
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0

  var locationStruct: Location? {
    let location = Location(latitude: latitude, longitude: longitude)

    return location
  }

  private let cards = LinkingObjects(fromType: RealmCard.self, property: "location")
  var card: RealmCard {
    return self.cards.first!
  }

  convenience init(location: Location) {
    self.init()

    self.latitude  = location.latitude
    self.longitude = location.longitude
  }
}
