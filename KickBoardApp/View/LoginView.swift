//
//  HomeView.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

import SnapKit

class LoginView: UIView {
  let mainLoginStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  let loginLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .white
    label.text = "로그인"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: CGFloat(30), weight: .bold)
    label.textColor = .black
    return label
  }()
  
  let idField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.borderStyle = .roundedRect
    textField.autocapitalizationType = .none
    // Placeholder 색상 바꾸는법
    textField.attributedPlaceholder = NSAttributedString(
      string: "아이디를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  
  let pwdField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.borderStyle = .roundedRect
    textField.autocapitalizationType = .none
    textField.isSecureTextEntry = true
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  
//  private let forgotPasswordButton: UIButton = {
//    let bt = UIButton(type: .system)
//    bt.setTitle("비밀번호찾기", for: .normal)
//    return bt
//  }()
  
  let loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("Login", for: .normal)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 10
    return button
  }()
  
  let joinButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("회원가입하기", for: .normal)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configureUI() {
    self.backgroundColor = .white
    
    self.addSubview(mainLoginStackView)
    [loginLabel, idField, pwdField, loginButton].forEach {
      mainLoginStackView.addArrangedSubview($0)
    }
    
    mainLoginStackView.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 300, height: 250))
      $0.center.equalToSuperview()
    }
        
    [joinButton]
      .forEach { self.addSubview($0) }
    
//    forgotPasswordButton.snp.makeConstraints {
//      $0.width.equalTo(200)
//      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
//      $0.centerX.equalToSuperview()
//    }
    
    joinButton.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
      $0.centerX.equalToSuperview()
    }
  }

}
