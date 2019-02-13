//
//  CardFlow.swift
//  Targot
//
//

//import Foundation
import UIKit
import RxFlow

class CardFlow: Flow {

  private let rootViewController: UINavigationController

  var root: Presentable {
    return self.rootViewController
  }

  init() {
    self.rootViewController = UINavigationController()
  }

  func navigate(to step: Step) -> NextFlowItems {
    guard let step = step as? TargotSteps else {
      return NextFlowItems.none
    }

    // TODO:
    switch step {
    default:
      return NextFlowItems.none
    }
  }

}
