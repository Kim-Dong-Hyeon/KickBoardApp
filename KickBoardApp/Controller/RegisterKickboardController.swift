//
//  RegisterKickboardController.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import UIKit
import PhotosUI
import CoreData


class RegisterKickboardController: UIViewController {
  private var registerKickboardView: RegisterKickboardView!
  var mapController: MapController!
  let coreDataManager = DataManager()
  let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
  override func loadView() {
    registerKickboardView = RegisterKickboardView(frame: UIScreen.main.bounds)
    self.view = registerKickboardView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerKickboardView.backgroundColor = .systemBackground
    self.title = "킥보드 등록"
    setButtonAction()
    setMapview()
    readRegistrant()
    readCurrentAddress()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapController.prepareEngine() // prepareEngine 호출
    mapController.activateEngine() // activateEngine 호출
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mapController.pauseEngine() // pauseEngine 호출
  }
  
  private func readCurrentAddress() {
    let location = CLLocation(latitude: 37.50236, longitude: 127.04444)
    let geocoder = CLGeocoder()
    let locale = Locale(identifier: "ko-KR")
    geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, error in
      guard let self = self else { return }
      guard let placemark = placemarks?.first else {
        print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
//      let administrativeArea = placemark.administrativeArea ?? ""
      let subLocality = placemark.subLocality ?? ""
      let name = placemark.name ?? ""
      let address = [/*administrativeArea,*/ subLocality, name].joined(separator: " ")
      self.registerKickboardView.adressValue.text = address
    }
  }
  private func setButtonAction() {
    registerKickboardView.selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
    registerKickboardView.mapView.currentLocationButton.addTarget(self, action: #selector(goToCurrentLocation), for: .touchUpInside)
    registerKickboardView.registerButton.addTarget(self, action: #selector(reigsterButtonTapped), for: .touchUpInside)
    registerKickboardView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
  }
  private func setMapview() {
    guard let mapController = mapController else { return }
//    addChild(mapController)
    registerKickboardView.mapView.addSubview(mapController.view)
    mapController.didMove(toParent: self)
    mapController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  private func registerKickBoardData() {
    guard let entity = NSEntityDescription.entity(forEntityName: KickBoard.className, in: container.viewContext) else { return }
    let newKickboard = NSManagedObject(entity: entity, insertInto: container.viewContext)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    newKickboard.setValue(registerKickboardView.registrantValue.text, forKey: KickBoard.Key.registrant)
    newKickboard.setValue(registerKickboardView.modelNameTextField.text, forKey: KickBoard.Key.modelName)
    newKickboard.setValue(registerKickboardView.adressValue.text, forKey: KickBoard.Key.registedLocation)
    newKickboard.setValue(UUID().uuidString, forKey: KickBoard.Key.id)
    newKickboard.setValue(registerKickboardView.currentDateLabel.text, forKey: KickBoard.Key.registedDate)
    newKickboard.setValue(dateFormatter.string(from: registerKickboardView.rentalPeriodDatePicker.date), forKey: KickBoard.Key.expirationDate)
    if let image = registerKickboardView.PhotoView.image {
      if let imageData = image.jpegData(compressionQuality: 1.0) {
        newKickboard.setValue(imageData ,forKey: KickBoard.Key.imageData)
      }
    }
    do {
      try container.viewContext.save()
      print("생성 성공")
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
  @objc private func goToCurrentLocation() {
    if let currentLocation = LocationManager.shared.currentLocation {
      (children.first as? MapController)?.updateCurrentLocation(location: currentLocation)
    }
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
