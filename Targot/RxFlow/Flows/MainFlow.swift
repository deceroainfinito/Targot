//
//  AppFlow.swift
//  Targot
//
//

import Foundation
import UIKit
import RxFlow

class MainFlow: Flow, HasRealmStorageManager {

  private let rootViewController: UINavigationController

  var root: Presentable {
    return self.rootViewController
  }

  init() {
    self.rootViewController = UINavigationController()
  }

  func navigate(to step: Step) -> NextFlowItems {
    guard let step = step as? TargotSteps else { return NextFlowItems.none }

    switch step {
    case .cardsList:
      return cardsList()
    case .newCardDetails(let stepper):
      return newCardDetails(stepper)
    case .cardDetails(withId: let id, andStepper: let stepper):
      guard let id = id else { fatalError("You can't get to anywhere without and id!") }
      return cardDetail(withId: id, andStepper: stepper)
    case .newCardDone:
      return newCardDone()
    case .addNewPhoto(let stepper):
      return addNewPhotoWithStepper(stepper)
    case .dismissNewPhoto:
      return dismissNewPhoto()
    case .settings:
      return settings()
    }
  }

  func cardsList() -> NextFlowItems {
    let cardsViewController       = CardsViewController()
    let presenter                 = CardsUIPresenter(withViewController: cardsViewController)
    cardsViewController.presenter = presenter

    rootViewController.pushViewController(cardsViewController, animated: true)

    return NextFlowItems.one(flowItem:
      NextFlowItem(nextPresentable: cardsViewController,
                   nextStepper: cardsViewController))
  }

  func newCardDetails(_ stepper: Stepper) -> NextFlowItems {
    let viewModel = CardDetailViewModel(card: Card())
    let cardController = CardViewController.instantiate(with: viewModel)
    let presenter = CardUIPresenter(withViewController: cardController)

    guard let stepper = stepper as? RecievesCard else { fatalError("Wrong Casting")}

    cardController.presenter = presenter
    cardController.delegate  = stepper

    rootViewController.pushViewController(cardController, animated: true)

    return NextFlowItems.one(flowItem:
      NextFlowItem.init(nextPresentable: cardController, nextStepper: cardController))
  }

  func settings() -> NextFlowItems {
    let settingsStepper = OneStepper(withSingleStep: TargotSteps.settings)
    let settingsFlow = SettingsFlow()

    Flows.whenReady(flow1: settingsFlow) { [unowned self] (root1: UIViewController) in
      self.rootViewController.present(root1, animated: true, completion: nil)
    }

    return NextFlowItems.one(flowItem:
      NextFlowItem.init(nextPresentable: settingsFlow,
                        nextStepper: settingsStepper))
  }

  func cardDetail(withId id: String, andStepper stepper: Stepper) -> NextFlowItems {
    // TODO: Chech the id!!
    guard let card = realmSM.getCardById(id) else { return NextFlowItems.none}
    let viewModel = CardDetailViewModel(card: card)
    let cardDetailViewController = CardViewController.instantiate(with: viewModel)
    let presenter = CardUIPresenter(withViewController: cardDetailViewController)

    guard let stepper = stepper as? RecievesCard else { fatalError("Wrong Casting!")}

    cardDetailViewController.presenter = presenter
    cardDetailViewController.delegate  = stepper

    rootViewController.pushViewController(cardDetailViewController, animated: true)

    return NextFlowItems.one(flowItem:
      NextFlowItem.init(nextPresentable: cardDetailViewController,
                        nextStepper: cardDetailViewController))
  }

  func newCardDone() -> NextFlowItems {
    rootViewController.popToRootViewController(animated: true)

    return NextFlowItems.none
  }

  func addNewPhotoWithStepper(_ stepper: Stepper) -> NextFlowItems {
    let viewModel = AddPhotoViewModel()
    let photoController = AddPhotoViewController.instantiate(with: viewModel)
    let photoPresenter  = AddPhotoPresenter(withViewController: photoController)
    guard let stepper = stepper as? RecievesPhotoIds else { fatalError("Wrong casting!!")}

    photoController.presenter = photoPresenter
    photoController.delegate  = stepper

    photoController.providesPresentationContextTransitionStyle = true
    photoController.definesPresentationContext                 = true
    photoController.modalPresentationStyle                     = .overCurrentContext
    photoController.modalTransitionStyle                       = .coverVertical

    self.rootViewController.present(photoController, animated: true, completion: nil)

    return NextFlowItems.one(flowItem: NextFlowItem.init(nextPresentable: photoController, nextStepper: photoController))
  }

  func dismissNewPhoto() -> NextFlowItems {
    rootViewController.dismiss(animated: true, completion: nil)

    return NextFlowItems.none
  }
}
