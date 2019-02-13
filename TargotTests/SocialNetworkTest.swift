//
//  SocialNetworkTest.swift
//  TargotTests
//
//

import XCTest
@testable import Targot

class SocialNetworkTest: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testSocialNetwork() {
    var socialN = SocialNetwork.facebook
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.on), #imageLiteral(resourceName: "icon_facebook_color"))
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.off), #imageLiteral(resourceName: "icon_facebook"))
    socialN = SocialNetwork.instagram
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.on), #imageLiteral(resourceName: "icon_IG_color"))
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.off), #imageLiteral(resourceName: "icon_IG"))
    socialN = SocialNetwork.twitter
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.on), #imageLiteral(resourceName: "icon_twitter_color"))
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.off), #imageLiteral(resourceName: "icon_twitter"))
    socialN = SocialNetwork.web
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.on), #imageLiteral(resourceName: "icon_web_color"))
    XCTAssertEqual(socialN.iconByState(SocialNetwork.State.off), #imageLiteral(resourceName: "icon_web"))
  }
}
