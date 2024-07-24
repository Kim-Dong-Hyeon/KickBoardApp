//
//  RegisterKickboardController.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import UIKit
import PhotosUI

class RegisterKickboardController: UIViewController {
  private var registerKickboardView: RegisterKickboardView!
  
  override func loadView() {
    registerKickboardView = RegisterKickboardView(frame: UIScreen.main.bounds)
    self.view = registerKickboardView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerKickboardView.backgroundColor = .systemBackground
    self.title = "킥보드 등록"
    
    registerKickboardView.selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
    registerKickboardView.mapView.currentLocationButton.addTarget(self, action: #selector(goToCurrentLocation), for: .touchUpInside)
    
    // 지도 초기화
    let mapController = MapController()
    addChild(mapController)
    registerKickboardView.mapView.addSubview(mapController.view)
    mapController.didMove(toParent: self)
    
    mapController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
