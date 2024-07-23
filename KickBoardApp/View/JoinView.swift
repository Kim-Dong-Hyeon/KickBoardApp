//
//  HomeView.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

import SnapKit

class JoinView: UIView {
  let mainJoinStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
    
  let idField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.autocapitalizationType = .none
    textField.borderStyle = .roundedRect
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
    textField.isSecureTextEntry = true
    textField.autocapitalizationType = .none
    textField.borderStyle = .roundedRect
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  
  let pwdChkField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.isSecureTextEntry = true
    textField.autocapitalizationType = .none
    textField.borderStyle = .roundedRect
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호를 한번더 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  
  let joinButton: UIButton = {
    let button = UIButton()
    button.setTitle("Join", for: .normal)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 10
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
    
    self.addSubview(mainJoinStackView)
    [idField, pwdField, pwdChkField, joinButton].forEach {
      mainJoinStackView.addArrangedSubview($0)
    }
    
    mainJoinStackView.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 300, height: 310))
      $0.center.equalToSuperview()
    }
  }
  
}
