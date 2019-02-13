//
//  DebugTest.swift
//  TargotTests
//
//

import os.log

import XCTest
@testable import Targot

class DebugTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testMessages() {
    Debug.thisDebug(message: "DEBUG")
    XCTAssertEqual(Debug.log, Debug.debug_oslog)
    XCTAssertEqual(Debug.type, OSLogType.debug)
    Debug.thisGuard(message: "GUARD")
    XCTAssertEqual(Debug.log, Debug.guard_oslog)
    XCTAssertEqual(Debug.type, OSLogType.debug)
    Debug.thisError(message: "ERROR")
    XCTAssertEqual(Debug.log, Debug.error_oslog)
    XCTAssertEqual(Debug.type, OSLogType.error)
    Debug.thisThrows(message: "THROWS")
    XCTAssertEqual(Debug.log, Debug.throws_oslog)
    XCTAssertEqual(Debug.type, OSLogType.error)
  }
}
