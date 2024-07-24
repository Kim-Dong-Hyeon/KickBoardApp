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
  var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func startUpdatingLocation() {
    checkAuthorizationStatus()
  }
  
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  private func checkAuthorizationStatus() {
    let status = locationManager.authorizationStatus
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    case .notDetermined:
      requestAuthorization()
    case .restricted, .denied:
      // Handle restricted/denied status by showing an alert or other appropriate actions
      print("Location access denied.")
    @unknown default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    currentLocation = location
    onLocationUpdate?(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    onAuthorizationChange?(status)
    checkAuthorizationStatus()
  }
}

//  private override init() {
//    super.init()
//    locationManager.delegate = self
//    locationManager.requestWhenInUseAuthorization()
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    locationManager.startUpdatingLocation()
//  }
//
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    guard let location = locations.last else { return }
//    currentLocation = location
//    onLocationUpdate?(location)
//  }
//
//  func startUpdatingLocation() {
//    locationManager.startUpdatingLocation()
//  }
//
//  func stopUpdatingLocation() {
//    locationManager.stopUpdatingLocation()
//  }
//}
