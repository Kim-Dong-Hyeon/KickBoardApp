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

  let homePlaceNameLabel: UILabel = {
    let label = UILabel()
    label.text = "서울특별시 관악구 신림동"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    label.textAlignment = .center
    label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    label.layer.cornerRadius = 10
    label.layer.borderWidth = 1.0
    label.layer.borderColor = UIColor.gray.cgColor
    label.clipsToBounds = true
    return label
  }()

  let currentLocationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setBackgroundImage(UIImage(named: "track_location_btn"), for: .normal)
    return button
  }()
  
  private let tapBarBackgroundLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  let modalAddressLabel: UILabel = {
    let label = UILabel()
    label.text = "관악구 신림로 330 (신림동)"
    label.textColor = UIColor(named: "KickColor")
    label.font = UIFont.systemFont(ofSize: 20, weight: .black)
    label.textAlignment = .left
    label.backgroundColor = .clear
    return label
  }()
  
  private let modalKickboardLabel: UILabel = {
    let label = UILabel()
    label.text = "대여 킥보드 정보"
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.textAlignment = .left
    label.backgroundColor = .clear
    return label
  }()
  
  private let modalKickboardImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFill
    image.image = UIImage(named: "testImage(Kickboard)")
    image.layer.borderWidth = 1.0
    image.layer.borderColor = UIColor.lightGray.cgColor
    image.layer.cornerRadius = 5.0
    image.clipsToBounds = true
    return image
  }()
  
  private let modalKickboardData1: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 13)
    label.text = "모델명"
    return label
  }()
  
  let modalKickboardData2: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.text = "Sparta1234"
    return label
  }()
  
  private let modalKickboardData3: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 13)
    label.text = "등록자"
    return label
  }()
  
  let modalKickboardData4: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.text = "전1성진"
    return label
  }()
  
  
  let modalButton1: AnimationButton = {
    let button = AnimationButton()
    button.setTitle("대여하기", for: .normal)
    return button
  }()
  
  let modalButton2: AnimationButton = {
    let button = AnimationButton()
    button.setTitle("닫기", for: .normal)
    return button
  }()
  
  private let modalButtonTemp: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .horizontal
    stackview.backgroundColor = .clear
    stackview.spacing = 40
    stackview.distribution = .fillEqually
    return stackview
  }()
  
  private let modalKickboardDataTemp1: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .vertical
    stackview.backgroundColor = .clear
    stackview.spacing = 5
    stackview.distribution = .fillEqually
    return stackview
  }()
  
  private let modalKickboardDataTemp2: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .vertical
    stackview.backgroundColor = .clear
    stackview.spacing = 5
    stackview.distribution = .fillEqually
    return stackview
  }()
  
  private let modalKickboardDataTemp3: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .vertical
    stackview.backgroundColor = .clear
    stackview.spacing = 10
    stackview.distribution = .fillEqually
    return stackview
  }()
  
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
      currentLocationButton,
      tapBarBackgroundLabel
    ].forEach { self.addSubview($0) }
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
    
    tapBarBackgroundLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-30)
      $0.width.equalTo(350)
      $0.height.equalTo(55)
    }
  }
  
  //모달 내부 세팅
  func halfModalUI() {
    halfModal.view.backgroundColor = .white
    
    [modalButton1, modalButton2].forEach {
      modalButtonTemp.addArrangedSubview($0)
      $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
      $0.backgroundColor = UIColor(named: "KickColor")
      $0.layer.cornerRadius = 10
    }

    [modalKickboardData1, modalKickboardData2].forEach {
      modalKickboardDataTemp1.addArrangedSubview($0)
      $0.textColor = .darkGray
      $0.textAlignment = .left
    }
    
    [modalKickboardData3, modalKickboardData4].forEach {
      modalKickboardDataTemp2.addArrangedSubview($0)
      $0.textColor = .darkGray
      $0.textAlignment = .left
    }
    
    [modalKickboardDataTemp1, modalKickboardDataTemp2].forEach {
      modalKickboardDataTemp3.addArrangedSubview($0)
    }
    
    let subviews = [
      modalButtonTemp,
      modalAddressLabel,
      modalKickboardLabel,
      modalKickboardImage,
      modalKickboardDataTemp3
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
      $0.height.equalTo(200)
      $0.width.equalTo(200)
    }
    
    modalKickboardDataTemp3.snp.makeConstraints {
      $0.leading.equalTo(modalKickboardImage.snp.trailing).offset(15)
      $0.bottom.equalTo(modalKickboardImage.snp.bottom)
      $0.height.equalTo(100)
      $0.width.equalTo(100)
    }
  }
}
