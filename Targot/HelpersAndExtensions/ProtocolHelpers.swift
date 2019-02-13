//
//  ProtocolHelpers.swift
//  Targot
//
//

import UIKit

protocol ViewModelBased: class {
  associatedtype ViewModel

  var viewModel: ViewModel! { get set }
}

extension ViewModelBased where Self:UIViewController {
  static func instantiate(with viewModel: ViewModel) -> Self {
    let viewController = Self()
    viewController.viewModel = viewModel

    return viewController
  }
}
