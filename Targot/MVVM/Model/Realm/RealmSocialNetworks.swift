//
//  RealmSocialNetworks.swift
//  Targot
//
//

import Foundation

import RealmSwift

class RealmSocialNetworks: IdObject {
  @objc dynamic var facebook: String?  = nil
  @objc dynamic var instagram: String? = nil
  @objc dynamic var twitter: String?   = nil
  @objc dynamic var web: String?       = nil

  let cards = LinkingObjects(fromType: RealmCard.self, property: "socialNetworks")
 
  var card: RealmCard {
    return self.cards.first!
  }

  convenience init(socialNetworks: SocialNetworks) {
    self.init()

    facebook  = socialNetworks[.facebook]
    instagram = socialNetworks[.instagram]
    twitter   = socialNetworks[.twitter]
    web       = socialNetworks[.web]
  }
}
