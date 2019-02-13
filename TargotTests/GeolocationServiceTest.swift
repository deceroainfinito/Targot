//
//  GeolocationServiceTest.swift
//  TargotTests
//
//

import CoreLocation
import RxSwift
import RxCoreLocation
import MapKit
import Contacts

import RxBlocking
import RxTest

import XCTest
@testable import Targot

class MockLocationManager: CLLocationManager {

  var mockLocation: CLLocation?
  override var location: CLLocation? {
    return mockLocation
  }
}

class GeolocationServiceTest: XCTestCase {

  var mockLS: MockLocationManager!
  var geoService: GeolocationService!
  var aPlacemark: MKPlacemark!

  override func setUp() {
    super.setUp()

    let coords = CLLocationCoordinate2DMake(51.5083, -0.1384)

    let address = [CNPostalAddressStreetKey: "181 Piccadilly",
                   CNPostalAddressCityKey: "London",
                   CNPostalAddressPostalCodeKey: "W1A 1ER",
                   CNPostalAddressCountryKey: "United Kingdom",
                   CNPostalAddressISOCountryCodeKey: "GB",]

    aPlacemark = MKPlacemark(coordinate: coords, addressDictionary: address)

    mockLS = MockLocationManager()
    mockLS.mockLocation = aPlacemark.location

    geoService = GeolocationService(withLocationManager: mockLS)
  }

  override func tearDown() {
    geoService = nil
    
    super.tearDown()
  }

  func testInit() {

    let promiseCity = XCTKVOExpectation(keyPath: "city",
                                        object: geoService.currentPlacemark?.postalAddress as Any,
                                        expectedValue: aPlacemark.postalAddress!.city)

    mockLS = MockLocationManager()
    mockLS.mockLocation = aPlacemark.location

    geoService = GeolocationService(withLocationManager: mockLS)

    XCTAssertEqual(mockLS, geoService.locationManager)
    XCTAssertEqual(kCLLocationAccuracyNearestTenMeters, geoService.locationManager.desiredAccuracy)

    XCTWaiter().wait(for: [promiseCity], timeout: 3)

    XCTAssertEqual(geoService.currentPlacemark?.postalAddress?.city, aPlacemark.postalAddress?.city)
  }

  func testCurrentLocation() {
    mockLS = MockLocationManager()
    geoService = GeolocationService(withLocationManager: mockLS)

    XCTAssertNil(geoService.getCurrentLocation())

    geoService.currentLocation = aPlacemark.location

    XCTAssertNotNil(geoService.getCurrentLocation())

    XCTAssertEqual(51.5083, geoService.getCurrentLocation()!.latitude)
    XCTAssertEqual(-0.1384, geoService.getCurrentLocation()!.longitude)
  }

  func testGetCurrentAddress() {
    mockLS = MockLocationManager()
    geoService = GeolocationService(withLocationManager: mockLS)

    XCTAssertNil(geoService.getCurrentAddress())

    geoService.currentPlacemark = aPlacemark

    let address = geoService.getCurrentAddress()

    XCTAssertEqual(aPlacemark.thoroughfare, address?.street)
    XCTAssertEqual(aPlacemark.postalCode, address?.zipCode)
    XCTAssertEqual(aPlacemark.locality, address?.city)
    XCTAssertEqual(aPlacemark.country, address?.country)
  }
}
