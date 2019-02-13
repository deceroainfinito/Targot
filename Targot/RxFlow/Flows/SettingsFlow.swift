//
//  SettingsFlow.swift
//  Targot
//
//

import UIKit
import RxFlow

class SettingsFlow: Flow {

  fileprivate let rootViewController: UINavigationController

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

    switch step {
    case .settings:
      return settings()
    default:
      return NextFlowItems.none
    }
  }

  func settings() -> NextFlowItems {
    let settingsViewController = UIViewController()
    settingsViewController.view.backgroundColor = UIColor.green

    rootViewController.pushViewController(settingsViewController, animated: true)

    return NextFlowItems.one(flowItem:
      NextFlowItem.init(nextPresentable: settingsViewController,
                        nextStepper: OneStepper.init(withSingleStep: TargotSteps.settings)))
  }
}
