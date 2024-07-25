//
//  HomeView.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/23/24.
//

import UIKit
import SnapKit

class HomeView: UIView {
  
  let mapView: UIView = {
    let view = UIView()
    return view
  }()
  
  let homePlaceNameLabel = {
    let label = UILabel()
    label.text = "서울특별시 관악구 신림동"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.textAlignment = .center
    label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    return label
  }()

  let currentLocationButton: UIButton = {
    let button = UIButton(type: .system)
    return button
  }()
  
  private let modalAddressLabel = {
    let label = UILabel()
    label.text = "관악구 신림로 330 (신림동)"
//    label.textColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 1, alpha: 1)
    label.textColor = UIColor(named: "KickColor")
    label.font = UIFont.systemFont(ofSize: 20, weight: .black)
    label.textAlignment = .left
    label.backgroundColor = .clear
    return label
  }()
  
  private let modalKickboardLabel = {
    let label = UILabel()
    label.text = "킥보드 정보"
    label.textColor = .darkGray
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .left
    label.backgroundColor = .clear
    return label
  }()
  
  private let modalKickboardImage = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.image = UIImage(named: "testImage(Kickboard)")
    return image
  }()
  
  private let modalKickboardData1 = {
    let label = UILabel()
    label.text = "시리얼넘버  @@@@@@@@@@@@"
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 13)
    label.textAlignment = .left
    label.backgroundColor = .clear
    return label
  }()
  
  private let modalKickboardData2 = {
    let label = UILabel()
    label.text = "등록자명  김솔비"
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 13)
    label.textAlignment = .left
    label.backgroundColor = .clear
    return label
  }()
  
  let modalButton1 = {
    let button = UIButton()
    button.setTitle("대여하기", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//    button.backgroundColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 1, alpha: 1)
    button.backgroundColor = UIColor(named: "KickColor")
    button.layer.cornerRadius = 10
    return button
  }()
  
  let modalButton2 = {
    let button = UIButton()
    button.setTitle("닫기", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//    button.backgroundColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 1, alpha: 1)
    button.backgroundColor = UIColor(named: "KickColor")
    button.layer.cornerRadius = 10
    return button
  }()
  
  private let modalButtonTemp = {
    let stackview = UIStackView()
    stackview.axis = .horizontal
    stackview.backgroundColor = .clear
    stackview.spacing = 40
    stackview.distribution = .fillEqually
    return stackview
  }()
  
  private let modalKickboardDataTemp = {
    let stackview = UIStackView()
    stackview.axis = .vertical
    stackview.backgroundColor = .clear
    stackview.spacing = 8
    stackview.distribution = .fillEqually
    return stackview
  }()
  
  //모달 테스트용 버튼(추후 지도 핑 클릭 시 오픈되도록 변경)
  let testButton = {
    let button = UIButton()
    button.setTitle("모오달", for: .normal)
    button.backgroundColor = .blue
    button.frame = CGRect(x: 70, y: 200, width: 50, height: 50)
    return button
  }()
  
  //네비게이션바 검색 기능(+캔슬기능)
//  let serchBar = UISearchController(searchResultsController: nil)
  let halfModal = UIViewController()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    halfModalUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("*T_T*")
  }
  
  private func setupViews() {
    [
      mapView,
      homePlaceNameLabel,
      testButton,
      currentLocationButton
    ].forEach { self.addSubview($0) }
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    testButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(200)
      $0.width.height.equalTo(50)
    }
    
    homePlaceNameLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().inset(40)
      $0.trailing.equalToSuperview().inset(40)
      $0.height.equalTo(40)
    }

    currentLocationButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(100)
      $0.width.height.equalTo(50)
    }
  }
  
  //모달 내부 세팅
  func halfModalUI() {
//    halfModal.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    halfModal.view.backgroundColor = .white
    
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
  }
}
