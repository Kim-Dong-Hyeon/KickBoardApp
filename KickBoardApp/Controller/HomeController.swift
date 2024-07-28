//
//  HomeController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import CoreLocation

import KakaoMapsSDK
import CoreData

class HomeController: UIViewController {
  var homeView: HomeView!
  var mapController: MapController!
  var state: Bool = false
//  var shouldDismissModal = false
  
  override func loadView() {
    homeView = HomeView(frame: UIScreen.main.bounds)
    self.view = homeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "킥보드 찾기"
    
    homeView.backgroundColor = .systemBackground
    homeView.currentLocationButton.addTarget(
      self,
      action: #selector(goToCurrentLocation),
      for: .touchUpInside
    )
    
    checkRideState()
    
    homeView.modalButton1.addAction(UIAction { [weak self] _ in
      guard let self = self else { return }
      self.setupAlert()
    }, for: .touchDown)
    
    setupMapController()
    
    mapController.homeDelegate = self
    
    // 위치 업데이트 콜백 설정
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.updatePlaceNameLabel(latitude: latitude, longitude: longitude)
      self?.goToCurrentLocation()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if state {
      setupHalfModal(id: UserDefaults.standard.object(forKey: "userName") as? String ?? "")
      homeView.modalButton2.isHidden = true
    }
    mapController.prepareEngine() // prepareEngine 호출
    mapController.activateEngine() // activateEngine 호출
    
    // 위치 업데이트 시작
    LocationManager.shared.startUpdatingLocation()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mapController.pauseEngine() // pauseEngine 호출
  }
  
  // MapController를 설정하는 메서드
  private func setupMapController() {
    mapController = MapController()
    addChild(mapController)
    homeView.mapView.addSubview(mapController.view)
    mapController.didMove(toParent: self)
    mapController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // 위치에 따라 주소 레이블을 업데이트하는 메서드
  func updatePlaceNameLabel(latitude: Double, longitude: Double) {
    let regionFetcher = RegionFetcher()
    regionFetcher.fetchRegion(longitude: longitude, latitude: latitude) {
      [weak self] documents, error in guard let self = self else { return }
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
  
  // 현재 위치로 이동하는 메서드
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
//    homeView.modalButton1.addAction(UIAction { [weak self] _ in
//      guard let self = self else { return }
//      self.setupAlert()
//    }, for: .touchDown)
    
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
      sheet.delegate = self
    }
    present(homeView.halfModal, animated: true, completion: nil)
  }
  
  // 모달 닫는 버튼에 들어갈 메서드 설정
  func closeHalfModal() {
    mapController.closedModal()
    dismiss(animated: true, completion: nil)
  }
  
//  // 빈 화면 터치 시 모달 창 내리기
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if !state {
//      self.dismiss(animated: true, completion: nil)
//    }
//  }
  
  // 대여하기 클릭 시 알럿
  func setupAlert() {
    let id = UserDefaults.standard.object(forKey: "userName") as? String
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    do {
      let request = User.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id ?? "")
      let users = try container.viewContext.fetch(request)
      
      for user in users as [NSManagedObject] {
        if state {
          state = false
          user.setValue(state, forKey: User.Key.state)
          homeView.modalButton2.isHidden = false
          let alert = UIAlertController(
            title: "알림",
            message: "반납이 완료되었습니다",
            preferredStyle: .alert
          )
          
          let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
          
          alert.addAction(ok)
          
          // 알럿이 모달 위로 뜨도록 설정
          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let topController = windowScene.windows.first?.rootViewController?.presentedViewController ?? windowScene.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
          } else {
            self.present(alert, animated: true, completion: nil)
          }
        } else {
          state = true
          user.setValue(state, forKey: User.Key.state)
          homeView.modalButton2.isHidden = true
        }
      }
      
      try container.viewContext.save()
      
      checkRideState()
      print("수정 성공")
    } catch {
      print("수정 실패")
    }  }
  
  func checkRideState() {
    let id: String = UserDefaults.standard.object(forKey: "userName") as? String ?? ""
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    do {
      let request = User.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id)
      let users = try container.viewContext.fetch(request)
      for user in users {
        state = user.state
      }
      print("조건 불러오기 성공")
    } catch {
      print("조건 불러오기 실패")
    }
    
    if state {
      homeView.modalButton1.setTitle("반납하기", for: .normal)
    } else {
      homeView.modalButton1.setTitle("대여하기", for: .normal)
    }
  }
}

protocol HomeControllerDelegate: AnyObject {
  func setupHalfModal(id: String)
  func closeHalfModal()
  func readCurrentAddress(latitude: Double, longitude: Double)
}

extension HomeController: HomeControllerDelegate {
  // 현재 주소를 읽는 메서드
  func readCurrentAddress(latitude: Double, longitude: Double) {
    let addressFetcher = AddressFetcher()
    addressFetcher.fetchAddress(
      latitude: latitude,
      longitude: longitude
    ) { [weak self] addressName, error in
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

extension HomeController: UISheetPresentationControllerDelegate {
  func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
    return false
  }
  
//  func setShouldDismissModal(_ shouldDismiss: Bool) {
//      self.shouldDismissModal = shouldDismiss
//  }
}
