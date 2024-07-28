//
//  RegisterKickboardController.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import UIKit
import PhotosUI
import CoreData

import KakaoMapsSDK

class RegisterKickboardController: UIViewController {
  private var registerKickboardView: RegisterKickboardView!
  var mapController: MapController!
  let coreDataManager = DataManager()
  let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  private var currentLatitude: Double?
  private var currentLongitude: Double?
  
  override func loadView() {
    registerKickboardView = RegisterKickboardView(frame: UIScreen.main.bounds)
    self.view = registerKickboardView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerKickboardView.backgroundColor = .systemBackground
    self.title = "킥보드 등록"
    
    setButtonAction()
    setupMapController()
    readRegistrant()
    
    LocationManager.shared.startUpdatingLocation()
    
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.currentLatitude = latitude
      self?.currentLongitude = longitude
      self?.mapController.updateCurrentLocation(latitude: latitude, longitude: longitude)
      self?.moveCameraToCurrentLocation(
        latitude: latitude,
        longitude: longitude,
        zoomLevel: 10
      ) // 여기에 줌 레벨 설정 추가
      self?.readCurrentAddress(latitude: latitude, longitude: longitude)
      print("현재 위도: \(latitude), 경도: \(longitude)") // 위치 업데이트 확인
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapController.poiVisible(false)
    mapController.prepareEngine()
    mapController.activateEngine()
    
    // 위치 업데이트 시작
    LocationManager.shared.startUpdatingLocation()
    
    // 초기 위치 설정 (기본 줌 레벨 적용)
    if let currentLocation = LocationManager.shared.currentLocation {
      let latitude = currentLocation.coordinate.latitude
      let longitude = currentLocation.coordinate.longitude
      self.readCurrentAddress(latitude: latitude, longitude: longitude)
      mapController.updateCurrentLocation(latitude: latitude, longitude: longitude)
      moveCameraToCurrentLocation(latitude: latitude, longitude: longitude, zoomLevel: 9)
    } else {
      LocationManager.shared.startUpdatingLocation()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mapController.poiVisible(true)
    mapController.pauseEngine()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    mapController.poisConfigure()
    mapController.viewInit(viewName: "mapview")
  }
  
  func moveCameraToCurrentLocation(latitude: Double, longitude: Double, zoomLevel: Int = 10) {
    let currentPosition = MapPoint(longitude: longitude, latitude: latitude)
    guard let kakaoMapView = mapController.kakaoMapView else { return }
    
    // 현재 위치로 카메라 이동
    let cameraUpdate = CameraUpdate.make(
      target: currentPosition,
      zoomLevel: zoomLevel,
      mapView: kakaoMapView
    )
    kakaoMapView.moveCamera(cameraUpdate)
    print("Camera moved to current position")
  }
  
  @objc private func goToCurrentLocation() {
    if let currentLatitude = LocationManager.shared.currentLocation?.coordinate.latitude,
       let currentLongitude = LocationManager.shared.currentLocation?.coordinate.longitude {
      mapController.updateCurrentLocation(latitude: currentLatitude, longitude: currentLongitude)
      moveCameraToCurrentLocation(
        latitude: currentLatitude,
        longitude: currentLongitude,
        zoomLevel: 17
      ) // 여기에 줌 레벨 설정 추가
    } else {
      LocationManager.shared.startUpdatingLocation()
    }
  }
  
  // 키보드 닫기
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func readCurrentAddress(latitude: Double, longitude: Double) {
    let addressFetcher = AddressFetcher()
    addressFetcher.fetchAddress(
      latitude: latitude,
      longitude: longitude
    ) { [weak self] addressName, error in
      if let addressName = addressName {
        DispatchQueue.main.async {
          self?.registerKickboardView.addressValue.text = addressName
          print("주소 갱신됨: \(addressName)")
        }
      } else if let error = error {
        DispatchQueue.main.async {
          self?.registerKickboardView.addressValue.text = "주소를 가져오지 못했습니다."
        }
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  
  private func setButtonAction() {
    registerKickboardView.selectPhotoButton.addTarget(
      self,
      action: #selector(selectPhotoButtonTapped),
      for: .touchUpInside
    )
    registerKickboardView.currentLocationButton.addTarget(
      self,
      action: #selector(goToCurrentLocation),
      for: .touchUpInside
    )
    registerKickboardView.registerButton.addTarget(
      self,
      action: #selector(reigsterButtonTapped),
      for: .touchUpInside
    )
    registerKickboardView.cancelButton.addTarget(
      self,
      action: #selector(cancelButtonTapped),
      for: .touchUpInside
    )
  }
  
  private func setupMapController() {
    mapController = MapController()
    addChild(mapController)
    registerKickboardView.mapView.addSubview(mapController.view)
    mapController.didMove(toParent: self)
    mapController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func registerKickBoardData() {
    guard let entity = NSEntityDescription.entity(
      forEntityName: KickBoard.className,
      in: container.viewContext
    ) else { return }
    let newKickboard = NSManagedObject(entity: entity, insertInto: container.viewContext)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    // 현재 위치를 LocationManager에서 직접 가져오기
    if let currentLocation = LocationManager.shared.currentLocation {
      currentLatitude = currentLocation.coordinate.latitude
      currentLongitude = currentLocation.coordinate.longitude
    } else {
      print("현재 위치를 가져오지 못했습니다.")
      return
    }
    
    newKickboard.setValue(currentLatitude, forKey: KickBoard.Key.currentLatitude)
    newKickboard.setValue(currentLongitude, forKey: KickBoard.Key.currentLongitude)
    newKickboard.setValue(
      registerKickboardView.registrantValue.text,
      forKey: KickBoard.Key.registrant
    )
    newKickboard.setValue(
      registerKickboardView.modelNameTextField.text,
      forKey: KickBoard.Key.modelName
    )
    newKickboard.setValue(
      registerKickboardView.addressValue.text,
      forKey: KickBoard.Key.registedLocation
    )
    newKickboard.setValue(UUID().uuidString, forKey: KickBoard.Key.id)
    newKickboard.setValue(
      dateFormatter.string(from: registerKickboardView.rentalPeriodDatePicker.date),
      forKey: KickBoard.Key.expirationDate
    )
    if let image = registerKickboardView.PhotoView.image {
      if let imageData = image.jpegData(compressionQuality: 1.0) {
        newKickboard.setValue(imageData ,forKey: KickBoard.Key.imageData)
      }
    }
    do {
      try container.viewContext.save()      
      print("등록 성공/현재 위도: \(currentLatitude ?? 0), 경도: \(currentLongitude ?? 0)") // 위도 경도 확인
    } catch {
      print("생성 실패")
    }
  }
  
  private func alertMessage(message: String, no: Bool) {
    let alertMessage = UIAlertController(title: message, message: "", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      if no {
        self.registerKickBoardData()
        self.clear()
      }
    }
    alertMessage.addAction(okAction)
    if no {
      let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      alertMessage.addAction(noAction)
    }
    present(alertMessage, animated: true, completion: nil)
  }
  
  private func readRegistrant() {
    guard let registrantName = UserDefaults.standard.string(forKey: "userName") else { return }
    registerKickboardView.registrantValue.text! = registrantName
  }
  
  private func clear() {
    registerKickboardView.modelNameTextField.text = ""
    registerKickboardView.PhotoView.image = .none
    registerKickboardView.rentalPeriodDatePicker.date = Date()
  }
  
  @objc private func cancelButtonTapped() {
    clear()
  }
  
  @objc private func reigsterButtonTapped() {
    switch (registerKickboardView.modelNameTextField.text!.isEmpty,
            registerKickboardView.PhotoView.image == .none) {
    case (true, false):
      alertMessage(message: "모델명을 입력해주세요.", no: false)
    case (false, true):
      alertMessage(message: "사진을 업로드해주세요.", no: false)
    case (true, true):
      alertMessage(message: "등록 화면을 확인해주세요.", no: false)
    default:
      alertMessage(message: "등록하시겠습니까?", no: true)
    }
  }
  
  @objc private func selectPhotoButtonTapped() {
    presentPhotoPicker()
  }
}

extension RegisterKickboardController: PHPickerViewControllerDelegate {
  func presentPhotoPicker() {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 1
    configuration.filter = .images
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    guard let provider = results.first?.itemProvider else { return }
    if provider.canLoadObject(ofClass: UIImage.self) {
      provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
        DispatchQueue.main.async {
          self?.registerKickboardView.PhotoView.image = image as? UIImage
        }
      }
    }
  }
}
