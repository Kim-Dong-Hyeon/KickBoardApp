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
  private var mapController: MapController!
  let coreDataManager = CoreDataManager()
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
  }
  private func setButtonAction() {
    registerKickboardView.selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
    registerKickboardView.mapView.currentLocationButton.addTarget(self, action: #selector(goToCurrentLocation), for: .touchUpInside)
    registerKickboardView.registerButton.addTarget(self, action: #selector(reigsterButtonTapped), for: .touchUpInside)
    registerKickboardView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
  }
  private func setMapview() {
    let mapController = MapController()
    addChild(mapController)
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
  
  
  private func readRegistrant() {
    guard let registrantName = UserDefaults.standard.string(forKey: "userName") else { return }
    registerKickboardView.registrantValue.text! = registrantName
  }
  @objc private func cancelButtonTapped() {
    registerKickboardView.modelNameTextField.text = ""
    registerKickboardView.PhotoView.image = .none
    registerKickboardView.rentalPeriodDatePicker.date = Date()
  }
  @objc private func reigsterButtonTapped() {
    registerKickBoardData()
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
