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
    label.text = "휴대전화 : "
    label.textAlignment = .center
    return label
  }()
  
  private lazy var gender: UILabel = {
    let label = UILabel()
    label.text = "회원등급"
    label.textAlignment = .center
    return label
  }()
  
  private lazy var myPageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    stackView.backgroundColor = .green
    return stackView
  }()
  
  private lazy var genderStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    stackView.backgroundColor = .blue
    return stackView
  }()
  
  private lazy var userImageView: UIView = {
    let stackView = UIView()
    stackView.backgroundColor = .yellow
    return stackView
  }()
  
  lazy var logOut: UIButton = {
    let button = UIButton()
    button.setTitle("로그아웃", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
  }()
  
  lazy var myPageList: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .gray
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setConstraints()
    getData()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.addSubview(myPageStackView)
    self.addSubview(logOut)
    [userImageView, myPageList].forEach{ myPageStackView.addArrangedSubview($0) }
    [userImage, genderStackView].forEach { userImageView.addSubview($0) }
    [nameLabel, phoneNumber, gender].forEach { genderStackView.addArrangedSubview($0) }
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
    
    genderStackView.snp.makeConstraints {
      $0.top.equalTo(userImage.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func getData() {
    let results = coreDataManager.readCoreData(entityType: User.self)
    for result in results {
      if result.id! == UserDefaults.standard.object(forKey: "userName") as! String {
        nameLabel.text! += result.name ?? ""
        phoneNumber.text! += result.phoneNumber ?? ""
      } else {
        print("값이없음")
        print("타입캐스팅 실패")
      }
    }
  }
}

