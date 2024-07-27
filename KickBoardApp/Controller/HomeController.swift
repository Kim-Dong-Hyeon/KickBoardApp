//
//  HomeController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import CoreLocation

import KakaoMapsSDK

class HomeController: UIViewController {
  var homeView: HomeView!
  var mapController: MapController!
  
  override func loadView() {
    homeView = HomeView(frame: UIScreen.main.bounds)
    self.view = homeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "킥보드 찾기"
    
    homeView.backgroundColor = .systemBackground
    homeView.currentLocationButton.addTarget(self, action: #selector(goToCurrentLocation), for: .touchUpInside)
    
    setupMapController()
    
    // 테스트버튼(추후 삭제 예정)
    homeView.testButton.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.setupHalfModal(id: "")
    }, for: .touchDown)
    
    mapController.homeDelegate = self
    
    // 위치 업데이트 콜백 설정
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.updatePlaceNameLabel(latitude: latitude, longitude: longitude)
      self?.goToCurrentLocation()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapController.prepareEngine() // prepareEngine 호출
    mapController.activateEngine() // activateEngine 호출
    
    // 위치 업데이트 시작
    LocationManager.shared.startUpdatingLocation()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mapController.pauseEngine() // pauseEngine 호출
  }
  
  private func setupMapController() {
    mapController = MapController()
    addChild(mapController)
    homeView.mapView.addSubview(mapController.view)
    mapController.didMove(toParent: self)
    mapController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
//  func readCurrentAddress(latitude: Double, longitude: Double) {
//    let addressFetcher = AddressFetcher()
//    addressFetcher.fetchAddress(latitude: latitude, longitude: longitude) { [weak self] addressName, error in
//      if let addressName = addressName {
//        DispatchQueue.main.async {
//          self?.homeView.modalAddressLabel.text = addressName
//          print("주소 갱신됨: \(addressName)")
//        }
//      } else if let error = error {
//        DispatchQueue.main.async {
//          self?.homeView.modalAddressLabel.text = "주소를 가져오지 못했습니다."
//        }
//        print("Error: \(error.localizedDescription)")
//      }
//    }
//  }
  
  // 홈탭 위치정보 텍스트 업데이트
  func updatePlaceNameLabel(latitude: Double, longitude: Double) {
    let regionFetcher = RegionFetcher()
    regionFetcher.fetchRegion(longitude: longitude, latitude: latitude) { [weak self] documents, error in
      guard let self = self else { return }
      if let document = documents?.first {
        DispatchQueue.main.async {
          self.homeView.homePlaceNameLabel.text = document.addressName
        }
      }
      if let error = error {
        print("Error fetching region: \(error)")
        return
      }
    }
  }
  
  @objc private func goToCurrentLocation() {
    if let currentLocation = LocationManager.shared.currentLocation {
      let latitude = currentLocation.coordinate.latitude
      let longitude = currentLocation.coordinate.longitude
      mapController.updateCurrentLocation(latitude: latitude, longitude: longitude)
      mapController.moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
      updatePlaceNameLabel(latitude: latitude, longitude: longitude)
    } else {
      LocationManager.shared.startUpdatingLocation()
    }
  }
  
  // 모달 내부 세팅
  func setupHalfModal(id: String) {
    // 모달 버튼 입력값(대여하기, 닫기)
    homeView.modalButton1.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.setupAlert()
    }, for: .touchDown)
    
    homeView.modalButton2.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.closeHalfModal()
    }, for: .touchUpInside)
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    do {
      let request = KickBoard.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id)
      // 속성으로 데이터 정렬해서 가져오기
      let kickBoards = try container.viewContext.fetch(request)
      for kickBoard in kickBoards {
        homeView.modalKickboardData2.text = "\(String(describing: kickBoard.modelName!))"
        homeView.modalKickboardData4.text = "\(String(describing: kickBoard.registrant!))"
      }
      print("조건 불러오기 성공")
    } catch {
      print("조건 불러오기 실패")
    }
    
    // 모달 상세 정보 사이즈 설정
    if let sheet = homeView.halfModal.sheetPresentationController {
      sheet.detents = [.medium()]
    }
    present(homeView.halfModal, animated: true, completion: nil)
  }
  
  // 모달 닫는 버튼에 들어갈 메서드 설정
  func closeHalfModal() {
    dismiss(animated: true, completion: nil)
  }
  
  // 빈 화면 터치 시 모달 창 내리기
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // 대여하기 클릭 시 알럿
  func setupAlert() {
    let alert = UIAlertController(
      title: "알림",
      message: "대여가 완료되었습니다",
      preferredStyle: .alert
    )
    
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    //    let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
    
    alert.addAction(ok)
    //    alert.addAction(cancel)
    
    // 알럿이 모달 위로 뜨도록 설정
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let topController = windowScene.windows.first?.rootViewController?.presentedViewController ?? windowScene.windows.first?.rootViewController {
      topController.present(alert, animated: true, completion: nil)
    } else {
      self.present(alert, animated: true, completion: nil)
    }
  }
}

protocol HomeControllerDelegate: AnyObject {
  func setupHalfModal(id: String)
  func closeHalfModal()
  func readCurrentAddress(latitude: Double, longitude: Double)
}

extension HomeController: HomeControllerDelegate {
  func readCurrentAddress(latitude: Double, longitude: Double) {
    let addressFetcher = AddressFetcher()
    addressFetcher.fetchAddress(latitude: latitude, longitude: longitude) { [weak self] addressName, error in
      if let addressName = addressName {
        DispatchQueue.main.async {
          self?.homeView.modalAddressLabel.text = addressName
          print("주소 갱신됨: \(addressName)")
        }
      } else if let error = error {
        DispatchQueue.main.async {
          self?.homeView.modalAddressLabel.text = "주소를 가져오지 못했습니다."
        }
        print("Error: \(error.localizedDescription)")
      }
    }
  }
}
