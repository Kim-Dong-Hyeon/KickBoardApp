//
//  MyPageView.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class MyPageView: UIView {
  
  private let coreDataManager = DataManager()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.text = "이름: "
    label.textAlignment = .center
    return label
  }()
  
  private lazy var userImage: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 50
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  private lazy var phoneNumber: UILabel = {
    let label = UILabel()
    label.text = "휴대전화: "
    label.textAlignment = .center
    return label
  }()
  
  private lazy var gender: UILabel = {
    let label = UILabel()
    label.text = "성별: "
    label.textAlignment = .center
    return label
  }()
  
  private lazy var isUsing: UILabel = {
    let label = UILabel()
    label.text = "미사용중"
    label.textColor = .red
    label.textAlignment = .center
    return label
  }()
  
  private lazy var myPageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var infoStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    stackView.backgroundColor = UIColor(named: "KickColor")
    stackView.layer.cornerRadius = 10
    return stackView
  }()
  
  private lazy var userImageView: UIView = {
    let stackView = UIView()
    return stackView
  }()
  
  lazy var logOut: UIButton = {
    let button = UIButton()
    button.setTitle("로그아웃", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.layer.cornerRadius = 10
    return button
  }()
  
  let uiView = UIView()
  
  lazy var moveUsageList: UIButton = {
    let button = UIButton()
    button.setTitle("나의 이용 내역", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = UIColor(named: "KickColor")
    button.layer.cornerRadius = 10
    return button
  }()

  
  lazy var moveHistoryList: UIButton = {
    let button = UIButton()
    button.setTitle("나의 등록 내역", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = UIColor(named: "KickColor")
    button.layer.cornerRadius = 10
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setConstraints()
//    getData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.addSubview(myPageStackView)
    self.addSubview(logOut)
    [userImageView, uiView].forEach{ myPageStackView.addArrangedSubview($0) }
    [moveUsageList, moveHistoryList].forEach { uiView.addSubview($0)}
    [userImage, infoStackView].forEach { userImageView.addSubview($0) }
    [nameLabel, isUsing, phoneNumber, gender].forEach { infoStackView.addArrangedSubview($0) }
  }
  
  private func setConstraints() {
    myPageStackView.snp.makeConstraints {
      $0.leading.trailing.top.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.bottom.equalTo(logOut.snp.top).offset(10)
    }
    
    logOut.snp.makeConstraints {
      $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
      $0.centerX.equalToSuperview()
    }
    
    userImage.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.height.equalTo(100)
      $0.centerX.equalToSuperview()
    }
    
    infoStackView.snp.makeConstraints {
      $0.top.equalTo(userImage.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    moveUsageList.snp.makeConstraints {
      $0.top.equalToSuperview().inset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50)
    }
    
    moveHistoryList.snp.makeConstraints {
      $0.top.equalTo(moveUsageList.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50)
    }
  }
  
  func getData() {
    let results = coreDataManager.readCoreData(entityType: User.self)
    for result in results {
      if result.id! == UserDefaults.standard.object(forKey: "userName") as! String {
        nameLabel.text! += result.name ?? ""
        phoneNumber.text! += result.phoneNumber ?? ""
        gender.text! += result.gender ?? ""
        print(result.state)
        if result.state {
          isUsing.text = "사용중"
          isUsing.textColor = .green
        } else {
          isUsing.text = "미사용중"
          isUsing.textColor = .red
        }
        switch result.gender {
        case "남자":
          userImage.image = UIImage(named: "man")
        default:
          userImage.image = UIImage(named: "woman")
        }
      }
    }
  }
}

