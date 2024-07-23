//
//  HomeController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
  
  private let modalAddressLabel = {
    let mAL = UILabel()
    mAL.text = "관악구 신림로 330 (신림동)"
    mAL.textColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 1, alpha: 1)
    mAL.font = UIFont.systemFont(ofSize: 20, weight: .black)
    mAL.textAlignment = .left
    mAL.backgroundColor = .clear
    return mAL
  }()
  
  private let modalKickboardLabel = {
    let mKL = UILabel()
    mKL.text = "킥보드 정보"
    mKL.textColor = .darkGray
    mKL.font = UIFont.boldSystemFont(ofSize: 20)
    mKL.textAlignment = .left
    mKL.backgroundColor = .clear
    return mKL
  }()
  
  private let modalKickboardImage = {
    let mKI = UIImageView()
    mKI.contentMode = .scaleAspectFit
    mKI.image = UIImage(named: "testImage(Kickboard)")
    return mKI
  }()
  
  private let modalKickboardData1 = {
    let mKD = UILabel()
    mKD.text = "시리얼넘버  @@@@@@@@@@@@"
    mKD.textColor = .darkGray
    mKD.font = UIFont.systemFont(ofSize: 13)
    mKD.textAlignment = .left
    mKD.backgroundColor = .clear
    return mKD
  }()
  
  private let modalKickboardData2 = {
    let mKD = UILabel()
    mKD.text = "등록자명  김솔비"
    mKD.textColor = .darkGray
    mKD.font = UIFont.systemFont(ofSize: 13)
    mKD.textAlignment = .left
    mKD.backgroundColor = .clear
    return mKD
  }()
  
  private let modalButton1 = {
    let mB1 = UIButton()
    mB1.setTitle("대여하기", for: .normal)
    mB1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    mB1.backgroundColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 1, alpha: 1)
    mB1.layer.cornerRadius = 10
    return mB1
  }()
  
  private let modalButton2 = {
    let mB2 = UIButton()
    mB2.setTitle("닫기", for: .normal)
    mB2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    mB2.backgroundColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 1, alpha: 1)
    mB2.layer.cornerRadius = 10
    return mB2
  }()
  
  private let modalButtonTemp = {
    let mBT = UIStackView()
    mBT.axis = .horizontal
    mBT.backgroundColor = .clear
    mBT.spacing = 40
    mBT.distribution = .fillEqually
    return mBT
  }()
  
  private let modalKickboardDataTemp = {
    let mKDT = UIStackView()
    mKDT.axis = .vertical
    mKDT.backgroundColor = .clear
    mKDT.spacing = 8
    mKDT.distribution = .fillEqually
    return mKDT
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "자전거 찾기"
    view.backgroundColor = .white
    
    setupNavigationBar()
    testButton()
  }

  //네비게이션바 검색 기능(+캔슬기능)
  func setupNavigationBar() {
    let serchBar = UISearchController(searchResultsController: nil)
    self.navigationItem.searchController = serchBar
  }
  
  //모달 테스트용 버튼(추후 지도 핑 클릭 시 오픈되도록 변경)
  func testButton() {
    let testButton = UIButton(type: .system)
    testButton.setTitle("모오달", for: .normal)
    testButton.addTarget(self, action: #selector(setupHalfModal), for: .touchUpInside)
    testButton.frame = CGRect(x: 70, y: 200, width: 50, height: 50)
    
    view.addSubview(testButton)
  }
  
  //모달 내부 세팅
  @objc func setupHalfModal() {
    let halfModal = UIViewController()
    halfModal.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    modalButtonTemp.addArrangedSubview(modalButton1)
    modalButtonTemp.addArrangedSubview(modalButton2)
    modalKickboardDataTemp.addArrangedSubview(modalKickboardData1)
    modalKickboardDataTemp.addArrangedSubview(modalKickboardData2)
    
    let subviews = [
      modalButtonTemp,
      modalAddressLabel,
      modalKickboardLabel,
      modalKickboardImage,
      modalKickboardDataTemp
    ]
    
    subviews.forEach { halfModal.view.addSubview($0) }
    
    modalButtonTemp.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(46)
      $0.width.equalTo(320)
    }
    
    modalAddressLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().inset(40)
      $0.height.equalTo(20)
      $0.width.equalTo(310)
    }
    
    modalKickboardLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(modalAddressLabel.snp.bottom).offset(20)
      $0.height.equalTo(20)
      $0.width.equalTo(310)
    }
    
    modalKickboardImage.snp.makeConstraints {
      $0.top.equalTo(modalKickboardLabel.snp.bottom).offset(15)
      $0.leading.equalToSuperview().inset(40)
      $0.height.equalTo(150)
      $0.width.equalTo(150)
    }
    
    modalKickboardDataTemp.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(modalKickboardImage.snp.bottom).offset(15)
      $0.height.equalTo(40)
      $0.width.equalTo(310)
    }
    
    //모달 버튼 입력값(대여하기, 닫기)
    modalButton1.addTarget(self, action: #selector(modalButton1Tapped), for: .touchUpInside)
    modalButton2.addTarget(self, action: #selector(closeHalfModal), for: .touchUpInside)
    
    //모달 상세 정보 사이즈 설정
    if let sheet = halfModal.sheetPresentationController {
      sheet.detents = [.medium()]
    }
    present(halfModal, animated: true, completion: nil)
  }
  
  @objc func modalButton1Tapped() {
    print("대여완료")
    setupAlert()
  }
  
  //모달 닫는 버튼에 들어갈 메서드 설정
  @objc func closeHalfModal() {
    dismiss(animated: true, completion: nil)
  }
  
  //빈 화면 터치 시 모달 창 내리기
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.dismiss(animated: true, completion: nil)
  }
  
  //대여하기 클릭 시 알럿
  func setupAlert() {
    let alert = UIAlertController(
      title: "알림",
      message: "대여가 완료되었습니다",
      preferredStyle: .alert
    )
    
    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
    //let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
    
    alert.addAction(ok)
    //alert.addAction(cancel)
    
    //알럿이 모달 위로 뜨도록 설정
    if let topController = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
      topController.present(alert, animated: true, completion: nil)
    }
  }
}
