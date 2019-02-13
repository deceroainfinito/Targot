//
//  RealmPhoto.swift
//  Targot
//
//

import Foundation

import RealmSwift
import Realm

class RealmPhoto: IdObject {
  @objc dynamic var localIdentifier: String = ""

  let visit = LinkingObjects(fromType: RealmVisit.self, property: "photos")
  let card  = LinkingObjects(fromType: RealmCard.self, property: "photos")

  convenience init(localIdentifier id: String) {
    self.init()
    self.localIdentifier = id
  }
}
