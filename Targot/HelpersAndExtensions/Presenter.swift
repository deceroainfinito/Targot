//
//  Presenter.swift
//  Targot
//
//

import UIKit

protocol PresenterDelegate: class {
  var viewController: UIViewController! { get set }

  func setupViews()
}

class Presenter: PresenterDelegate {
  var viewController: UIViewController!

  func setupViews() { }
}

extension Presenter {
  convenience init(withViewController viewController: UIViewController) {
    self.init()
    self.viewController = viewController
  }
}
