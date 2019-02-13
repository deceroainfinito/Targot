//
//  Card.swift
//  Targot
//
//

import Foundation

typealias PhotoId = String

struct Card {

  var id: String?
  var name: String = ""
  var date = Date()

  var address: Address?

  var phoneNumber: String?

  var location: Location?

  var visits: [Visit]    = []
  var photos: [PhotoId]  = []

  var notes: String?
  var category: CategoryValue = CategoryValue.none

  var socialNetworks: SocialNetworks = [:]
}

public enum Category: Int {
  case bars, leisure, sports, culture

  static let descriptions = [NSLocalizedString("CategoryBars", comment: ""),
                             NSLocalizedString("CategoryLeisure", comment: ""),
                             NSLocalizedString("CategorySports", comment: ""),
                             NSLocalizedString("CategoryCulture", comment: "")]

  public var description: String {
    return Category.descriptions[self.rawValue]
  }
}

struct Location {
  var latitude: Double
  var longitude: Double
}

struct Address {
  // CLPlacemark's thoroughfare
  var street: String?

  var zipCode: String?
  var city: String?
  var country: String?

  var completeAddress: String? {
    return [street, zipCode, city].compactMap({ $0 }).filter({ !$0.isEmpty }) .joined(separator: ", ")
  }
}

struct Visit {
  var title: String = ""
  var date = Date()
  var comment: String?
  var stars: Int = 0

  var photos: [PhotoId] = []
}
