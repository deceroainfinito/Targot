//
//  RealmDomain.swift
//  Targot
//
//

import Foundation

import RealmSwift

@objc protocol Ideable: AnyObject{
  @objc var id: String { get set }
  //  @objc dynamic var id: String { get set }
}

class IdObject: Object, Ideable {
  @objc dynamic var id = UUID().uuidString

  override static func primaryKey() -> String? {
    return "id"
  }
}
