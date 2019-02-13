//
//  FontBuilder.swift
//  Targot
//
//

import UIKit

struct FontBuilder {
  enum FontName: String {
    case abulaBold    = "Abula-Bold"
    case noyhRLight   = "NoyhR-Light"
    case noyhRMedium  = "NoyhR-Medium"
    case noyhRRegular = "NoyhR-Regular"
    case noyhrBold    = "NoyhR-Bold"
  }

  enum FontExt: String {
    case ttf, otf
  }

  enum FontSize: Int {
    case label = 54, bigField  = 84

    public var cgPixels: CGFloat {
      return self.rawValue.cgPixels
    }
  }

  let name: FontName
  let ext: FontExt
  let size: FontSize = FontSize.label

  var fontURL: URL? {
    return Bundle.main.url(forResource: self.name.rawValue, withExtension: self.ext.rawValue)
  }

  func uiFont(size: CGFloat) -> UIFont? {
    return UIFont(name: self.name.rawValue, size: CGFloat(size))
  }

  static var abulaBold: FontBuilder = {
    return FontBuilder(name: .abulaBold, ext: .otf)
  }()
  static var noyhRLight: FontBuilder = {
    return FontBuilder(name: .noyhRLight, ext: .ttf)
  }()
  static var noyhRMedium: FontBuilder = {
    return FontBuilder(name: .noyhRMedium, ext: .ttf)
  }()
  static var noyhRRegular: FontBuilder  = {
    return FontBuilder(name: .noyhRRegular, ext: .ttf)
  }()
  static var noyhrBold:FontBuilder = {
    return FontBuilder(name: .noyhrBold, ext: .ttf)
  }()
}

