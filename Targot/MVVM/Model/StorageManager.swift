//
//  StorageManager.swift
//  Targot
//
//

import RealmSwift

protocol StorageManager {
  func fetchAllCards() -> [Card]
  func createCard(_ card: Card) throws -> String
}

public enum RealmStorageManagerError: Error {
  case unsuccessfullInit
  case cantKillThemAll
  case cantCreateCard
  case cantUpdateCard
  case noIdCantUpdateCard
  case noCardCantUpdateCard
}

class RealmStorageManager: StorageManager {

  let realm: Realm

  init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) throws {
    do {
      realm = try Realm(configuration: configuration)
    } catch {
      Debug.thisError(message: error.localizedDescription)
      throw RealmStorageManagerError.unsuccessfullInit
    }
  }

  func killThemAll() throws {
    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch let error {
      Debug.thisError(message: error.localizedDescription)
      throw RealmStorageManagerError.cantKillThemAll
    }
  }

  func fetchAllCards() -> [Card] {
    return realm.objects(RealmCard.self).map({ (realmCard) -> Card in
      return realmCard.cardStruct
    })
  }

  func getCardById(_ id: String) -> Card? {
    guard let card = realm.object(ofType: RealmCard.self, forPrimaryKey: id) else { return nil}

    return card.cardStruct
  }

  func createCard(_ card: Card) throws -> String {
    let newCard = RealmCard(card: card)

    do {
      try realm.write {
        // TODO: Remove this !!!!
        realm.add(newCard)
      }
    } catch let error {
      Debug.thisError(message: error.localizedDescription)
      throw RealmStorageManagerError.cantCreateCard
    }

    return newCard.id
  }

  func updateCard(_ card: Card) throws -> String {
    guard let id = card.id
      else { throw RealmStorageManagerError.noIdCantUpdateCard }
    guard let realmCard = realm.object(ofType: RealmCard.self, forPrimaryKey: id)
      else { throw RealmStorageManagerError.noCardCantUpdateCard }

    do {
      try realm.write {
        realmCard.fullfillWithCard(card)
        realm.add(realmCard, update: true)
      }
    } catch let error {
      Debug.thisError(message: error.localizedDescription)
      throw RealmStorageManagerError.cantUpdateCard
    }

    return realmCard.id
  }
}
