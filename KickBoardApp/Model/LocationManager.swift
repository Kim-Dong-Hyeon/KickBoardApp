//
//  LocationManager.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/23/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()
  
  private let locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var onLocationUpdate: ((CLLocation) -> Void)?
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    currentLocation = location
    onLocationUpdate?(location)
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
}
