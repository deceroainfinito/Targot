//
//  Constants.swift
//  Targot
//
//

import UIKit

struct Constants {
  static let TargotAlbumName = "Targot"
}

public enum TargotColors: Int {
  case azulete,
       verdete,
       moradete,
       rosete,
       naranjete,
       blackGrisete,
       griseteIcons,
       darkGrisete,
       lightGrisete,
       borderUp,
       borderDown

  static let hexValues = [
    0x5789fa,
    0x28ceba,
    0xad5cff,
    0xfb7c91,
    0xfeaa4f,
    0xefeff4,
    0xa0a1a1,
    0x555555,
    0xEBF0F3,
    0xE0E5E9,
    0xE4E5E8
  ]

  public var color: UIColor {
    return try! UIColor(hex: TargotColors.hexValues[self.rawValue])
  }

  public var cgColor: CGColor {
    return self.color.cgColor
  }

  static func byCategory(_ category: CategoryValue) -> UIColor {
    switch category {
    case .none:
      return TargotColors.griseteIcons.color
    case .shopping:
      return TargotColors.moradete.color
    case .sport:
      return TargotColors.naranjete.color
    case .leisure:
      return TargotColors.rosete.color
    case .barest:
      return TargotColors.verdete.color
    }
  }
}
