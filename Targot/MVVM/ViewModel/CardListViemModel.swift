//
//  TargotListViemModel.swift
//  Targot
//
//

import RxSwift

public enum CardSortingCriteria {
  case name(CardOrderCriteria)
  case distance(CardOrderCriteria)
}

public enum CardOrderCriteria {
  case ascending, descending
}

struct CardsViewModel {

  var realmSM: RealmStorageManager = {
    var rSM: RealmStorageManager!
    do {
      rSM = try RealmStorageManager()
    } catch let error {
      Debug.thisError(message: error.localizedDescription)
    }

    return rSM
  }()

  func cards() -> [CardCellViewModel] {
    let cards: [CardCellViewModel] = realmSM.fetchAllCards().map { (card) -> CardCellViewModel in

      return CardCellViewModel(card: card)
    }

    return cards
  }
  
//
//  func filteredCards(_ criteria: CardSortingCriteria) {
//    switch criteria {
//    case .name(let order):
//      if order == CardOrderCriteria.ascending {
//        cards.value.sort(by: { $0.name < $1.name })
//      }
//      cards.value.sort(by: { $0.name > $1.name })
//    case .distance(let distance):
//      print("TODO: Use let distance: \(distance)")
//    }
//  }
}
