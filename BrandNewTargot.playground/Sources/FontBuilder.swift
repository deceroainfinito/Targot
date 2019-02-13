//
//  FontBuilder.swift
//  Targot
//

import UIKit

public extension Int {
  var pixels: Int {
    return Int(round(CGFloat(self) / UIScreen.main.scale))
  }

  var cgPixels: CGFloat {
    return CGFloat(pixels)
  }

  func pointsToPixels() -> CGFloat {
    return CGFloat(ceil(CGFloat(self) / UIScreen.main.scale))
  }
}

public enum FontClassName: String {
  case noyhrBold = "NoyhR-Bold"
  case abulaBold = "Abula-Bold"
  case noyhRMedium = "NoyhR-Medium"
}

public enum FontClassExt: String {
  case noyhrBold, noyhRMedium = "ttf"
  case abulaBold = "otf"
}

public class FontBuilder {
  let fontURL: URL?

  init(fontName: FontClassName, fontExt: FontClassExt) {
    fontURL = Bundle.main.url(forResource: fontName.rawValue, withExtension: fontExt.rawValue)
  }
}
