//
//  MapController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import CoreLocation

import KakaoMapsSDK

class MapController: UIViewController, MapControllerDelegate, GuiEventDelegate, CLLocationManagerDelegate {
  
  private var mapController: KMController?
  private var observerAdded = false
  private var isAuth = false
  private var isAppear = false
  private var mapView = MapView()
  private var kakaoMapView: KakaoMap?
  private var currentLocationMarker: Poi?
  
  override func loadView() {
    mapView = MapView(frame: UIScreen.main.bounds)
    self.view = mapView
  }
  
  private var apiSampleView: MapView {
    return self.view as! MapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    apiSampleView.currentLocationButton.addTarget(self, action: #selector(goToCurrentLocation), for: .touchUpInside)
    
    mapController = KMController(viewContainer: apiSampleView.mapContainer)
    mapController?.delegate = self
    
    LocationManager.shared.onLocationUpdate = { [weak self] location in
      self?.updateCurrentLocation(location: location)
    }
    
    LocationManager.shared.startUpdatingLocation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
    isAppear = true
    prepaerAndActivateEngine()
//    if mapController?.isEnginePrepared == false {
//      mapController?.prepareEngine()
//    }
//    if mapController?.isEngineActive == false {
//      mapController?.activateEngine()
//    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    isAppear = false
    mapController?.pauseEngine()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    removeObservers()
    mapController?.resetEngine()
  }
  
  func prepaerAndActivateEngine() {
    if mapController?.isEnginePrepared == false {
      mapController?.prepareEngine()
    }
    if mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
  }
  
  func authenticationSucceeded() {
    if !isAuth {
      isAuth = true
    }
    if isAppear && mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
  }
  
  func authenticationFailed(_ errorCode: Int, desc: String) {
    print("error code: \(errorCode)")
    print("desc: \(desc)")
    isAuth = false
    switch errorCode {
    case 400:
      apiSampleView.showToast(message: "지도 종료(API인증 파라미터 오류)")
    case 401:
      apiSampleView.showToast(message: "지도 종료(API인증 키 오류)")
    case 403:
      apiSampleView.showToast(message: "지도 종료(API인증 권한 오류)")
    case 429:
      apiSampleView.showToast(message: "지도 종료(API 사용쿼터 초과)")
    case 499:
      apiSampleView.showToast(message: "지도 종료(네트워크 오류) 5초 후 재시도..")
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        print("retry auth...")
        self.mapController?.prepareEngine()
      }
    default:
      break
    }
  }
  
  func addViews() {
    let defaultPosition = MapPoint(longitude: 127.108678, latitude: 37.402001)
    let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
    mapController?.addView(mapviewInfo)
  }
  
  func viewInit(viewName: String) {
    print("OK")
  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    if let view = mapController?.getView("mapview") as? KakaoMap {
      view.viewRect = apiSampleView.mapContainer.bounds
      kakaoMapView = view
      viewInit(viewName: viewName)
    }
  }
  
  func addViewFailed(_ viewName: String, viewInfoName: String) {
    print("Failed")
  }
  
  func containerDidResized(_ size: CGSize) {
    if let mapView = mapController?.getView("mapview") as? KakaoMap {
      mapView.viewRect = CGRect(origin: .zero, size: size)
    }
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    observerAdded = true
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    observerAdded = false
  }
  
  @objc private func willResignActive() {
    mapController?.pauseEngine()
  }
  
  @objc private func didBecomeActive() {
    mapController?.activateEngine()
  }
  
  @objc private func goToCurrentLocation() {
    LocationManager.shared.startUpdatingLocation()
  }
  
  private func updateCurrentLocation(location: CLLocation) {
    let currentPosition = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
    guard let kakaoMapView = kakaoMapView else { return }
    
    // 현재 위치로 카메라 이동
    let cameraUpdate = CameraUpdate.make(target: currentPosition, zoomLevel: 17, mapView: kakaoMapView)
    kakaoMapView.moveCamera(cameraUpdate)
    print("Camera moved to current position")
    
    // 현재 위치 마커 추가
    if currentLocationMarker == nil {
      print("Creating new current location marker")
      // PoiStyle 생성
      let manager = kakaoMapView.getLabelManager()
      let iconStyle = PoiIconStyle(symbol: UIImage(named: "current_location_marker.png"))
      let poiStyle = PoiStyle(styleID: "currentLocationStyle", styles: [
        PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
      ])
      manager.addPoiStyle(poiStyle)
      print("POI style added")
      
      // 레이어 옵션 생성
      let layerOptions = LabelLayerOptions(
        layerID: "default",
        competitionType: .none,
        competitionUnit: .symbolFirst,
        orderType: .rank,
        zOrder: 1000
      )
      // 레이어 추가 또는 기존 레이어 가져오기
      let layer = manager.getLabelLayer(layerID: "default") ?? manager.addLabelLayer(option: layerOptions)
      let poiOption = PoiOptions(styleID: "currentLocationStyle")
      currentLocationMarker = layer?.addPoi(option: poiOption, at: currentPosition)
      print("POI added")
    } else {
      // Poi 위치 업데이트
      print("Updating current location marker position")
      currentLocationMarker?.position = currentPosition
    }
    
    currentLocationMarker?.show()
    print("Current location marker shown")
  }
}
