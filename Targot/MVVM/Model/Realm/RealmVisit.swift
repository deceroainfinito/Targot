//
//  RealmVisit.swift
//  Targot
//
//

import Foundation

import RealmSwift

class RealmVisit: IdObject {
  
  let card = LinkingObjects(fromType: RealmCard.self, property: "visits")
  
  @objc dynamic var title: String = NSLocalizedString("No title", comment: "")
  @objc dynamic var comment: String?
  @objc dynamic var stars = 0
  @objc dynamic var date = Date()

  let photos = List<RealmPhoto>()

  var visitStruct: Visit {

    var visit = Visit()

    visit.title = self.title
    visit.comment = self.comment
    visit.stars = self.stars
    visit.date = self.date

    visit.photos = self.photos.map({ (realmPhoto) -> String in
      return realmPhoto.localIdentifier
    })

    return visit
  }

  override static func ignoredProperties() -> [String] {
    return ["visitStruct"]
  }
}
