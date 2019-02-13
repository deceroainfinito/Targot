//
//  CardCellViewModel.swift
//  Targot
//
//

import RxSwift

class CardCellViewModel {
  var card: Card

  var name: Variable<String?>     = Variable(nil)
  var address: Variable<String?>  = Variable(nil)
  var phone: Variable<String?>    = Variable(nil)
  var stars: Variable<String>     = Variable("0")
  var distance: Variable<String?> = Variable("0")
  var visits: Variable<String>    = Variable("")
  var category: Variable<Int?>    = Variable(0)

  lazy var visitsStars: String = {
    guard !card.visits.isEmpty else { return "0" }

    let total = card.visits.reduce(0) { (result, visit) -> Int in
      result + visit.stars
    }

    let median = total / card.visits.count

    return "\(median)"
  }()

  lazy var formattedPhoneNumber: String? = {
    return card.phoneNumber?.splitBy(" ", each: 3)
  }()

  var categoryValue: CategoryValue {
    return CategoryValue(rawValue: category.value ?? 0)!
  }

  init(card: Card) {
    self.card = card

    assignValues()
  }

  func updateWithCard(_ card: Card) {
    self.card = card
    assignValues()
  }

  fileprivate func assignValues() {
    name.value     = card.name.uppercased()
    address.value  = card.address?.completeAddress
    distance.value = "TODO"
    visits.value   = "\(card.visits.count)"
    category.value = card.category.rawValue
    stars.value    = visitsStars
    phone.value    = formattedPhoneNumber
  }
}
