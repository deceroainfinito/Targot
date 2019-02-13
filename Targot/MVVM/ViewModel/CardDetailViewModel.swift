//
//  CardDetailViewModel.swift
//  Targot
//
//

import RxSwift

protocol HasRealmStorageManager {
  var realmSM: RealmStorageManager { get }
}

extension HasRealmStorageManager {
  var realmSM: RealmStorageManager {
    var rSM: RealmStorageManager!
    do {
      rSM = try RealmStorageManager()
    } catch let error {
      Debug.thisError(message: error.localizedDescription)
    }

    return rSM
  }
}


class CardDetailViewModel: HasRealmStorageManager {
  var card: Card

  var name:      Variable<String?>       = Variable(nil)
  var category:  Variable<CategoryValue> = Variable(CategoryValue.none)
  var address:   Variable<String?>       = Variable(nil)
  var latitude:  Variable<Double?>       = Variable(nil)
  var longitude: Variable<Double?>       = Variable(nil)
  var city:      Variable<String?>       = Variable(nil)
  var zipCode:   Variable<String?>       = Variable(nil)
  var phone:     Variable<String?>       = Variable(nil)
  var facebook:  Variable<String?>       = Variable(nil)
  var instagram: Variable<String?>       = Variable(nil)
  var twitter:   Variable<String?>       = Variable(nil)
  var web:       Variable<String?>       = Variable(nil)
  var notes:     Variable<String?>       = Variable(nil)

  var photos: Variable<[String]> = Variable([])

  init(card: Card) {
    self.card = card
  }

  var isNewCard: Bool {
    return self.card.id == nil
  }

  func assignFirstValues() {
    name.value      = card.name
    category.value  = card.category
    latitude.value  = card.location?.latitude
    longitude.value = card.location?.longitude
    address.value   = card.address?.street
    city.value      = card.address?.city
    zipCode.value   = card.address?.zipCode
    phone.value     = card.phoneNumber
    facebook.value  = card.socialNetworks[.facebook]
    instagram.value = card.socialNetworks[.instagram]
    twitter.value   = card.socialNetworks[.twitter]
    web.value       = card.socialNetworks[.web]
    notes.value     = card.notes

    photos.value.append(contentsOf: card.photos)
  }

  func setLocation(_ location: Location) {
    self.latitude.value  = location.latitude
    self.longitude.value = location.longitude
  }

  func setAddress(_ address: Address) {
    self.address.value = address.street
    self.city.value    = address.city
    self.zipCode.value = address.zipCode
  }

  func save() -> String? {
    card.name     = name.value ?? ""
    card.category = category.value

    if let lat = latitude.value, let lon = longitude.value {
      let loc = Location(latitude: lat, longitude: lon)
      card.location = loc
    }

    let tempAddress = Address(street: address.value,
                              zipCode: zipCode.value,
                              city: city.value,
                              country: "TODO")

    card.address = tempAddress

    card.phoneNumber                = phone.value
    card.socialNetworks[.facebook]  = facebook.value
    card.socialNetworks[.instagram] = instagram.value
    card.socialNetworks[.twitter]   = twitter.value
    card.socialNetworks[.web]       = web.value
    card.notes                      = notes.value
    card.photos                     = photos.value

    do {
      if card.id != nil {
        return try realmSM.updateCard(card)
      } else {
        card.id = try realmSM.createCard(card)
        return card.id
      }
    } catch {
      Debug.thisError(message: error.localizedDescription)
      return nil
    }
  }
}
