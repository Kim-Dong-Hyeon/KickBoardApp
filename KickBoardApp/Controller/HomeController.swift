//
//  HomeController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
  private let mapController = MapController()
  var homeView: HomeView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tabBarController?.viewControllers?[1].tabBarItem.title = "킥보드등록"
    self.tabBarController?.viewControllers?[1].tabBarItem.image = UIImage(systemName: "person.fill")
    self.tabBarController?.viewControllers?[2].tabBarItem.title = "마이페이지"
    self.tabBarController?.viewControllers?[2].tabBarItem.image = UIImage(systemName: "person.fill")
    self.title = "자전거 찾기"
//    self.add(mapController)
    self.tabBarController?.tabBarItem.image = UIImage(systemName: "house")
    
    homeView = HomeView()
    self.view.addSubview(homeView)
    homeView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    homeView.backgroundColor = .white
    
    setupNavigationBar()
    
    // 테스트버튼(추후 삭제 예정)
    homeView.testButton.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.setupHalfModal()
    }, for: .touchDown)
  }
  
  private func add(_ child: UIViewController) {
    addChild(child)
    view.addSubview(child.view)
    child.view.frame = view.bounds
    child.didMove(toParent: self)
  }
  
  // 네비게이션바 검색 기능(+캔슬기능)
  func setupNavigationBar() {
    self.navigationItem.searchController = homeView.serchBar
  }
  
  //모달 내부 세팅
  func setupHalfModal() {
    //모달 버튼 입력값(대여하기, 닫기)
    homeView.modalButton1.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.setupAlert()
    }, for: .touchDown)
    
    homeView.modalButton2.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.closeHalfModal()
    }, for: .touchDown)
    
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
    
    alert.addAction(ok)
    
    // 알럿이 모달 위로 뜨도록 설정
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let topController = windowScene.windows.first?.rootViewController?.presentedViewController ?? windowScene.windows.first?.rootViewController {
      topController.present(alert, animated: true, completion: nil)
    } else {
      self.present(alert, animated: true, completion: nil)
    }
  }
}
