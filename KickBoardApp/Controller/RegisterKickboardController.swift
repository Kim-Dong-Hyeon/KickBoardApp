//
//  RegisterKickboardController.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import Foundation
import UIKit
import PhotosUI
class RegisterKickboardController: UIViewController {
  var mapController: MapController!
  var registerKickboardView: RegisterKickboardView!
  override func loadView() {
    registerKickboardView = RegisterKickboardView(frame: UIScreen.main.bounds)
    self.view = registerKickboardView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerKickboardView.backgroundColor = .systemBackground
    self.title = "킥보드 등록"
    registerKickboardView.selectPhotoButton.addTarget(self, action: #selector(selectPhotoButtonTapped), for: .touchUpInside)
    
    setupMapView()
  }
  @objc private func selectPhotoButtonTapped() {
    presentPhotoPicker()
  }
  
  private func setupMapView() {
    mapController = MapController()
    registerKickboardView.mapView.addSubview(mapController.view)
    
    DispatchQueue.main.async {
      self.mapController.view.frame = self.registerKickboardView.mapView.bounds
      self.mapController.prepaerAndActivateEngine()
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
