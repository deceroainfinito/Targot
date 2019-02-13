//
//  OwnExtensions.swift
//  Targot
//
//

import UIKit

extension Int {
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

extension String {
  mutating func splitedBy(_ character: Character, each: Int) {
    self = splitBy(character, each: each)
  }

  func splitBy(_ character: Character, each: Int) -> String {
    var split = self
    var i = 0
    var offset = 0
    var safeIndex = split.index(startIndex, offsetBy: each * i + offset, limitedBy: split.endIndex)

    while safeIndex != nil {
      split.insert(character, at: safeIndex!)
      i += 1
      offset += 1

      safeIndex = split.index(startIndex, offsetBy: each * i + offset, limitedBy: split.endIndex)
    }

    return split.trimmingCharacters(in: .whitespaces)
  }
}
