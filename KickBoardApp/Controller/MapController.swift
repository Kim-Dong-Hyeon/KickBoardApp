//
//  MapController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import CoreLocation

import KakaoMapsSDK

class MapController: UIViewController, MapControllerDelegate, GuiEventDelegate, CLLocationManagerDelegate, KakaoMapEventDelegate {
  private var mapController: KMController?
  private var observerAdded = false
  private var isAuth = false
  private var isAppear = false
  private var mapView = MapView()
  private var kakaoMapView: KakaoMap?
  private var currentLocationMarker: Poi?
  var homePlaceNameLabel: UILabel?
  
  // 지도 상태를 저장할 변수
  private var lastMarkerPosition: MapPoint?
  private var lastZoomLevel: Int?
  
  // 마커 관련 변수
  private var positions = [MapPoint]()
  private var options = [PoiOptions]()
  private var pois = [String: Poi]()
  private var _clickedPoiID: String = ""
  
  // homeContorllerDelegate 설정
  var homeDelegate: HomeControllerDelegate!
  
  override func loadView() {
    mapView = MapView(frame: UIScreen.main.bounds)
    self.view = mapView
  }
  
  deinit {
    mapController?.pauseEngine()
    mapController?.resetEngine()

    print("deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapController = KMController(viewContainer: mapView.mapContainer)
    mapController?.delegate = self
    
    LocationManager.shared.onLocationUpdate = { [weak self] location in
      self?.updateCurrentLocation(location: location)
      self?.updatePlaceNameLabel(location: location)
    }
    
    LocationManager.shared.onAuthorizationChange = { [weak self] status in
      self?.handleAuthorizationChange(status)
    }
    
    LocationManager.shared.startUpdatingLocation()
    
    poisConfigure()
  }
  
  //홈탭 위치정보 텍스트 업데이트
  func updatePlaceNameLabel(location: CLLocation) {
    CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
      guard let self = self else { return }
      if let placemark = placemarks?.first {
        DispatchQueue.main.async {
          // 올바른 주소 추출
          let administrativeArea = placemark.administrativeArea ?? ""  // 서울특별시
          let subAdministrativeArea = placemark.subAdministrativeArea ?? ""  // 강남구 등
          let subLocality = placemark.subLocality ?? ""  // 역삼동 등
          
          // 주소 문자열 생성
          let address = "\(administrativeArea) \(subAdministrativeArea) \(subLocality)".trimmingCharacters(in: .whitespacesAndNewlines)
          
          // 주소 텍스트 업데이트
          self.homePlaceNameLabel?.text = address
        }
      }
    }
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
    let defaultPosition = MapPoint(longitude: 127.04444, latitude: 37.50236)
    let mapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
    mapController?.addView(mapviewInfo)
  }
  
  func viewInit(viewName: String) {
    print("OK")
    // Style 생성
    createPoiStyles()
    // LabelLayer 생성.
    createLabelLayer()
    // LabelLayer 생성.
    createPois()

  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    if let view = mapController?.getView("mapview") as? KakaoMap {
      view.viewRect = mapView.mapContainer.bounds
      view.eventDelegate = self // KakaoMapEventDelegate 설정
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
    if let currentLocation = LocationManager.shared.currentLocation {
      updatePlaceNameLabel(location: currentLocation)
    }
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
      print("Location access denied. Please enable location services in settings.")
    default:
      break
    }
  }
}

extension MapController {
  // Poi가 어떻게 표시될지를 지정하는 Style 생성.
  func createPoiStyles() {
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    let manager = mapView.getLabelManager()
    let iconStyle = PoiIconStyle(symbol: UIImage(named: "search_ico_pin_map.png"), anchorPoint: CGPoint(x: 0.5, y: 0.999), transition: PoiTransition(entrance: .scale, exit: .scale))
    let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
    manager.addPoiStyle(PoiStyle(styleID: "label_clicked_style", styles: [perLevelStyle]))
    
    let smallIconStyle = PoiIconStyle(symbol: UIImage(named: "search_ico_pin_small_map.png"), anchorPoint: CGPoint(x: 0.5, y: 0.999), transition: PoiTransition(entrance: .scale, exit: .scale))
    let perLevelStyle2 = PerLevelPoiStyle(iconStyle: smallIconStyle, level: 0)
    manager.addPoiStyle(PoiStyle(styleID: "label_default_style", styles: [perLevelStyle2]))
  }
  
  // LabelLayer 생성. 하나의 LabelLayer는 여러개의 Poi를 포함할 수 있다.
  func createLabelLayer() {
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    let labelManager = mapView.getLabelManager()
    
    let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
    let _ = labelManager.addLabelLayer(option: layer)
  }
  
  // PoiOptions을 이용하여 Poi를 화면에 표시한다.
  func createPois() {
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    let labelManager = mapView.getLabelManager()
    
    let layer = labelManager.getLabelLayer(layerID: "poiLayer")
    if let items = layer?.addPois(options: options, at: positions) {
      // POI들 가져와서 이벤트 적용
      for item in items {
        item.clickable = true
        item.addPoiTappedEventHandler(target: self, handler: MapController.poiTapped)
        pois[item.itemID] = item
      }
    }
    
    mapView.moveCamera(CameraUpdate.make(area: AreaRect(points: positions)))
    layer?.showAllPois()
  }
  
  func poisConfigure() {
    let datas = PoiDataSample.createPoiData()
    for data in datas {
      let option = PoiOptions(styleID: data.styleID, poiID: data.id)
      option.clickable = true
      options.append(option)
    }
    
    // Poi 표시 위치를 지정하기위해, dummy data에서 위치정보만 빼내서 따로 저장해둠.
    positions = PoiDataSample.datas.map {
      MapPoint(longitude: $0.position.longitude, latitude: $0.position.latitude)
    }
  }
  
  func poiTapped(_ param: PoiInteractionEventParam) {
    print("하이")
    print(param.poiItem.itemID)
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    let manager = mapView.getLabelManager()
    let layer = manager.getLabelLayer(layerID: param.poiItem.layerID)
    let trackingManager = mapView.getTrackingManager()
    
    if let poi = layer?.getPoi(poiID: param.poiItem.itemID) {
      if let clickedPoi = layer?.getPoi(poiID: _clickedPoiID), clickedPoi.itemID == poi.itemID {
        print("이미 선택됨")
        clickedPoi.changeStyle(styleID: "label_default_style")
        trackingManager.stopTracking()
        homeDelegate.closeHalfModal()
      } else {
        poi.hide()
        poi.changeStyle(styleID: "label_clicked_style")
        poi.show()
        trackingManager.startTrackingPoi(poi)
        homeDelegate.setupHalfModal(id: poi.itemID)
      }
      
      _clickedPoiID = poi.itemID
    }
  }
}
