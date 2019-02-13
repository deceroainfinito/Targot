//
//  RealmCard.swift
//  Targot
//
//

import Foundation

import RealmSwift

class RealmCard: IdObject {

  @objc dynamic var name = ""
  @objc dynamic var date = Date()

  @objc dynamic var address: RealmAddress?

  @objc dynamic var phoneNumber: String?

  @objc dynamic var location: RealmLocation?

  let visits = List<RealmVisit>()

  @objc dynamic var notes: String?

  let category = RealmOptional<Int>()

  @objc dynamic var socialNetworks: RealmSocialNetworks?

  let photos = List<RealmPhoto>()

  var cardStruct: Card {
    var card = Card()

    card.id = self.id
    card.name = self.name
    card.address = self.address?.addressStruct
    card.phoneNumber = self.phoneNumber
    card.location = self.location?.locationStruct

    // TODO: Visits

    card.notes = self.notes
    card.category = CategoryValue(rawValue: self.category.value ?? 0) ?? CategoryValue.none

    card.photos.append(contentsOf: self.photos.map({ $0.localIdentifier }))

    return card
  }

  convenience init(card: Card) {
    self.init()
    self.name = card.name
    self.date = card.date

    if let cardAddress = card.address {
      let address = RealmAddress(address: cardAddress)
      self.address = address
    }

    self.phoneNumber = card.phoneNumber

    if let cardLocation = card.location {
      let location = RealmLocation(location: cardLocation)
      self.location = location
    }

    // TODO: visits

    self.notes = card.notes

    self.category.value = card.category.rawValue

    let socialNetworks = RealmSocialNetworks(socialNetworks: card.socialNetworks)
    self.socialNetworks = socialNetworks

    card.photos.forEach { (id) in
      let realmPhoto = RealmPhoto(localIdentifier: id)
      self.photos.append(realmPhoto)
    }
  }

  func fullfillWithCard(_ card: Card) {
    self.name = card.name
    self.date = card.date

    if let cardAddress = card.address {
      self.address?.street = cardAddress.street
      self.address?.zipCode = cardAddress.zipCode
      self.address?.city = cardAddress.city
      self.address?.country = cardAddress.country
    }

    self.phoneNumber = card.phoneNumber

    if let cardLocation = card.location {
      self.location?.latitude = cardLocation.latitude
      self.location?.longitude = cardLocation.longitude
    }

    // TODO: visits

    self.notes = card.notes

    self.category.value = card.category.rawValue

    self.socialNetworks?.facebook = card.socialNetworks[.facebook]
    self.socialNetworks?.instagram = card.socialNetworks[.instagram]
    self.socialNetworks?.twitter = card.socialNetworks[.twitter]
    self.socialNetworks?.web = card.socialNetworks[.web]

    self.photos.removeAll()
    self.photos.append(objectsIn: card.photos.map({ (id) -> RealmPhoto in
      RealmPhoto(localIdentifier: id)
    }))
  }

  override static func ignoredProperties() -> [String] {
    return ["cardStruct"]
  }

  override static func indexedProperties() -> [String] {
    return ["name", "date"]
  }
}
