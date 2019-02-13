//
//  Debug.swift
//  Targot
//
//
import os.log

import UIKit

struct Debug {

  static let subsystem = Bundle.main.bundleIdentifier ?? "Targot"

  enum LogCategory: String {
    case _guard, _error, _debug, _throws
  }

  static var log: OSLog!
  static var type: OSLogType!

  static let guard_oslog = OSLog(subsystem: subsystem, category: LogCategory._guard.rawValue)
  static let error_oslog = OSLog(subsystem: subsystem, category: LogCategory._error.rawValue)
  static let debug_oslog = OSLog(subsystem: subsystem, category: LogCategory._debug.rawValue)
  static let throws_oslog = OSLog(subsystem: subsystem, category: LogCategory._throws.rawValue)

  static func thisGuard(message: String) {
    log = guard_oslog; type = .debug
    log(message: message)
  }
  static func thisError(message: String) {
    log = error_oslog; type = .error
    log(message: message)
  }
  static func thisDebug(message: String) {
    log = debug_oslog; type = .debug
    log(message: message)
  }

  static func thisThrows(message: String) {
    log = throws_oslog; type = .error
    log(message: message)
  }

  fileprivate static func log(message: String) {
    os_log("%@", log: Debug.log, type: Debug.type, message)
  }
}
