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
  
  // 지도 상태를 저장할 변수
  private var lastMarkerPosition: MapPoint?
  private var lastZoomLevel: Int?
  
  override func loadView() {
    mapView = MapView(frame: UIScreen.main.bounds)
    self.view = mapView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.currentLocationButton.addTarget(self, action: #selector(goToCurrentLocation), for: .touchUpInside)
    
    mapController = KMController(viewContainer: mapView.mapContainer)
    mapController?.delegate = self
    
    LocationManager.shared.onLocationUpdate = { [weak self] location in
      self?.updateCurrentLocation(location: location)
    }
    
    LocationManager.shared.onAuthorizationChange = { [weak self] status in
      self?.handleAuthorizationChange(status)
    }
    
    LocationManager.shared.startUpdatingLocation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
    isAppear = true
    if mapController?.isEnginePrepared == false {
      mapController?.prepareEngine()
    }
    if mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
    restoreMapState()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    isAppear = false
    pauseEngine()
    saveMapState()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    removeObservers()
    // 지도 엔진을 재설정하지 않도록 주석 처리
    //    resetEngine()
  }
  
  func prepareEngine() {
    mapController?.prepareEngine()
  }
  
  func activateEngine() {
    mapController?.activateEngine()
  }
  
  func pauseEngine() {
    mapController?.pauseEngine()
  }
  
  func resetEngine() {
    mapController?.resetEngine()
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
      mapView.showToast(message: "지도 종료(API인증 파라미터 오류)")
    case 401:
      mapView.showToast(message: "지도 종료(API인증 키 오류)")
    case 403:
      mapView.showToast(message: "지도 종료(API인증 권한 오류)")
    case 429:
      mapView.showToast(message: "지도 종료(API 사용쿼터 초과)")
    case 499:
      mapView.showToast(message: "지도 종료(네트워크 오류) 5초 후 재시도..")
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
      view.viewRect = mapView.mapContainer.bounds
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
  
  func updateCurrentLocation(location: CLLocation) {
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
    
    // 현재 위치를 저장
    lastMarkerPosition = currentPosition
    print("현재 마커 위치:\(String(describing: lastMarkerPosition))")
  }
  
  func saveMapState() {
    guard let kakaoMapView = kakaoMapView else { return }
    lastMarkerPosition = currentLocationMarker?.position
    lastZoomLevel = Int(kakaoMapView.zoomLevel)
  }
  
  func restoreMapState() {
    guard let kakaoMapView = kakaoMapView, let position = lastMarkerPosition, let zoomLevel = lastZoomLevel else { return }
    let cameraUpdate = CameraUpdate.make(target: position, zoomLevel: Int(zoomLevel), mapView: kakaoMapView)
    kakaoMapView.moveCamera(cameraUpdate)
    if let currentLocationMarker = currentLocationMarker {
      currentLocationMarker.position = position
      currentLocationMarker.show()
    } else {
      let manager = kakaoMapView.getLabelManager()
      let iconStyle = PoiIconStyle(symbol: UIImage(named: "current_location_marker.png"))
      let poiStyle = PoiStyle(styleID: "currentLocationStyle", styles: [
        PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
      ])
      manager.addPoiStyle(poiStyle)
      let layerOptions = LabelLayerOptions(
        layerID: "default",
        competitionType: .none,
        competitionUnit: .symbolFirst,
        orderType: .rank,
        zOrder: 1000
      )
      let layer = manager.getLabelLayer(layerID: "default") ?? manager.addLabelLayer(option: layerOptions)
      let poiOption = PoiOptions(styleID: "currentLocationStyle")
      currentLocationMarker = layer?.addPoi(option: poiOption, at: position)
      currentLocationMarker?.show()
    }
  }
  
  private func handleAuthorizationChange(_ status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      LocationManager.shared.startUpdatingLocation()
    case .denied, .restricted:
      // 위치 권한이 거부된 경우 적절한 처리를 수행 (예: 알림 표시)
      print("Location access denied. Please enable location services in settings.")
    default:
      break
    }
  }
}
