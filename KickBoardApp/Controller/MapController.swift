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
  var kakaoMapView: KakaoMap?
  private var currentLocationMarker: Poi?
  
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
    
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.updateCurrentLocation(latitude: latitude, longitude: longitude)
//      self?.moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
    }
    
    LocationManager.shared.onAuthorizationChange = { [weak self] status in
      self?.handleAuthorizationChange(status)
    }
    
    poisConfigure()
    
    // 초기 위치 설정 (지도가 준비된 후)
    mapController?.prepareEngine()
    mapController?.activateEngine()
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
    // 여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
    let defaultPosition: MapPoint = MapPoint(longitude: 127.04444, latitude: 37.50236)
    // 지도(KakaoMap)를 그리기 위한 viewInfo를 생성
    let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
    
    // KakaoMap 추가
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
      
      // 지도 준비 후 현재 위치로 이동
      if let currentLocation = LocationManager.shared.currentLocation {
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        updateCurrentLocation(latitude: latitude, longitude: longitude)
//        moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
      } else {
        LocationManager.shared.startUpdatingLocation()
      }
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
  
//  @objc private func goToCurrentLocation() {
//    if let currentLatitude = LocationManager.shared.currentLocation?.coordinate.latitude,
//       let currentLongitude = LocationManager.shared.currentLocation?.coordinate.longitude {
//      updateCurrentLocation(latitude: currentLatitude, longitude: currentLongitude)
//    } else {
//      LocationManager.shared.startUpdatingLocation()
//    }
//  }
  
  func moveCameraToCurrentLocation(latitude: Double, longitude: Double, zoomLevel: Int = 17) {
    let currentPosition = MapPoint(longitude: longitude, latitude: latitude)
    guard let kakaoMapView = kakaoMapView else { return }
    
    // 현재 위치로 카메라 이동
    let cameraUpdate = CameraUpdate.make(target: currentPosition, zoomLevel: zoomLevel, mapView: kakaoMapView)
    kakaoMapView.moveCamera(cameraUpdate)
    print("Camera moved to current position")
  }
  
  func updateCurrentLocation(latitude: Double, longitude: Double) {
    let currentPosition = MapPoint(longitude: longitude, latitude: latitude)
    guard let kakaoMapView = kakaoMapView else { return }
    
    // 현재 위치 마커 추가
    if currentLocationMarker == nil {
      print("Creating new current location marker")
      let manager = kakaoMapView.getLabelManager()
      let iconStyle = PoiIconStyle(symbol: UIImage(named: "current_location_marker.png"))
      let poiStyle = PoiStyle(styleID: "currentLocationStyle", styles: [
        PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
      ])
      manager.addPoiStyle(poiStyle)
      print("POI style added")
      
      let layerOptions = LabelLayerOptions(
        layerID: "default",
        competitionType: .none,
        competitionUnit: .symbolFirst,
        orderType: .rank,
        zOrder: 1000
      )
      let layer = manager.getLabelLayer(layerID: "default") ?? manager.addLabelLayer(option: layerOptions)
      let poiOption = PoiOptions(styleID: "currentLocationStyle")
      currentLocationMarker = layer?.addPoi(option: poiOption, at: currentPosition)
      print("POI added")
    } else {
      print("Updating current location marker position")
      currentLocationMarker?.position = currentPosition
    }
    
    currentLocationMarker?.show()
    print("Current location marker shown")
    
    // 현재 위치를 저장
    lastMarkerPosition = currentPosition
    print("현재 마커 위치:\(String(describing: lastMarkerPosition))")
    moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
  }
  
  func saveMapState() {
    guard let kakaoMapView = kakaoMapView else { return }
    lastMarkerPosition = currentLocationMarker?.position
    lastZoomLevel = Int(kakaoMapView.zoomLevel)
    print("[saveMapState] 현재 마커 위치:\(String(describing: lastMarkerPosition)), 줌 레벨:\(String(describing: lastZoomLevel))")
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
  
  // Poi를 지도에 표시: PoiOptions을 이용하여 Poi를 화면에 표시한다.
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
  
  // Poi 구성
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
  
  // Poi 탭 이벤트 핸들러
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
      
      homeDelegate.readCurrentAddress(latitude: poi.position.wgsCoord.latitude, longitude: poi.position.wgsCoord.longitude)
      
    }
  }
}
