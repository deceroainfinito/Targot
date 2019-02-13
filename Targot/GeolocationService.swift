//  GeolocationService.swift
//  Targot
//
//

import UIKit
import CoreLocation

import RxSwift
import RxCoreLocation

class GeolocationService: NSObject {
  
  var locationManager: CLLocationManager!
  
  var geoCoder = CLGeocoder()
  
  @objc var currentPlacemark: CLPlacemark?
  @objc var currentLocation: CLLocation?
  
  var disposeBag = DisposeBag()
  
  convenience init(withLocationManager loc: CLLocationManager) {
    self.init()
    
    locationManager = loc
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 3
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()

    locationManager.rx.placemark.subscribe(onNext: { [unowned self] (placemark) in
      self.currentPlacemark = placemark
    }).disposed(by: disposeBag)
  }

  deinit {
    geoCoder.cancelGeocode()
    locationManager.stopUpdatingLocation()
    locationManager = nil
  }

  func getCurrentLocation() -> (latitude: Double, longitude: Double)? {
    guard let lat = currentLocation?.coordinate.latitude,
      let lon = currentLocation?.coordinate.longitude else { return nil }
    return (latitude: lat, longitude: lon)
  }

  func getCurrentAddress() -> Address? {
    guard let cPlacemark = currentPlacemark else { return nil}

    let address = Address(street: cPlacemark.thoroughfare,
                          zipCode: cPlacemark.postalCode,
                          city: cPlacemark.locality,
                          country: cPlacemark.country)

    return address
  }
}
