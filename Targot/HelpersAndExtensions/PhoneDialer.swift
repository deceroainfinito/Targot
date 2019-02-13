//
//  PhoneDialer.swift
//  Targot
//
//

import UIKit

protocol URLOpenerProtocol {
  func canOpenURL(_ url: URL) -> Bool
  func open(_ url: URL,
              options: [UIApplication.OpenExternalURLOptionsKey : Any],
              completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: URLOpenerProtocol { }

struct PhoneDialer {

  enum PhoneDialerError: Error {
    case incorrectOrEmptyNumber
    case noSuitableUIApplication
  }

  private let app: URLOpenerProtocol

  init(application: URLOpenerProtocol) {
    self.app = application
  }

  func callPhoneNumer(_ phoneNumber: String?) throws {
    guard let phoneNumber = phoneNumber, !phoneNumber.isEmpty else { throw PhoneDialerError.incorrectOrEmptyNumber }
    guard let url = URL(string: "tel://\(phoneNumber)"), self.app.canOpenURL(url) else { throw PhoneDialerError.noSuitableUIApplication }

    self.app.open(url, options: [:], completionHandler: nil)
  }
}
