//
//  SocialNetwork.swift
//  Targot
//
//

import Foundation
import UIKit

public enum SocialNetwork: String {

  public enum State: String { case on = "On", off = "Off" }

  case facebook, instagram, twitter, web

  public func iconByState(_ state: State) -> UIImage? {
    let iconName: String!

    switch self {
    case .facebook:
      iconName = NSLocalizedString("FacebookIcon\(state.rawValue)", comment: "")
    case .instagram:
      iconName = NSLocalizedString("InstagramIcon\(state.rawValue)", comment: "")
    case .twitter:
      iconName = NSLocalizedString("TwitterIcon\(state.rawValue)", comment: "")
    case .web:
      iconName = NSLocalizedString("WebIcon\(state.rawValue)", comment: "")
    }

    return UIImage(named: iconName)
  }
}

public typealias SocialNetworks = [SocialNetwork: String]
