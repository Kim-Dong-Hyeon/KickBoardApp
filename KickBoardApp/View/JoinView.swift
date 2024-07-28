//
//  JoinView.swift
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
    textField.attributedPlaceholder = NSAttributedString(
      string: "아이디",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  let pwdField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.isSecureTextEntry = true
    textField.textContentType = .oneTimeCode
    textField.autocapitalizationType = .none
    textField.borderStyle = .roundedRect
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  let pwdChkField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.isSecureTextEntry = true
    textField.textContentType = .oneTimeCode
    textField.autocapitalizationType = .none
    textField.borderStyle = .roundedRect
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호 확인",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  let nameField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.borderStyle = .roundedRect
    textField.autocapitalizationType = .none
    textField.attributedPlaceholder = NSAttributedString(
      string: "이름",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    return textField
  }()
  let genderView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIColor.systemGray5.cgColor
    view.layer.cornerRadius = 5.0
    view.layer.masksToBounds = true
    return view
  }()
  let genderLabel: UILabel = {
    let label = UILabel()
    label.text = "남자"
    return label
  }()
  let genderChangeButton: UIButton = {
    let button = UIButton()
    button.setTitle("선택", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    return button
  }()
  let phoneNumberField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.backgroundColor = .white
    textField.borderStyle = .roundedRect
    textField.autocapitalizationType = .none
    textField.attributedPlaceholder = NSAttributedString(
      string: "전화번호",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
    )
    textField.keyboardType = .asciiCapableNumberPad
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
    configureGenderMenu()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configureUI() {
    self.backgroundColor = .white
    
    [ mainJoinStackView ].forEach { self.addSubview($0) }
    
    [
      idField,
      pwdField,
      pwdChkField,
      nameField,
      genderView,
      phoneNumberField,
      joinButton
    ].forEach { mainJoinStackView.addArrangedSubview($0) }
    
    [
      genderLabel,
      genderChangeButton
    ].forEach { genderView.addSubview($0) }
    
    mainJoinStackView.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 300, height: 310))
      $0.center.equalToSuperview()
    }
    
    genderLabel.snp.makeConstraints {
      $0.left.equalToSuperview().offset(8)
      $0.centerY.equalToSuperview()
    }
    
    genderChangeButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().offset(-8)
      $0.size.equalTo(CGSize(width: 40, height: 30))
    }
  }
  
  private func configureGenderMenu() {
    var actions: [UIAction] = []
    for gender in ["남자", "여자"] {
      let action = UIAction(title: gender, handler: { [weak self] (action) in
        guard let self = self else { return }
        self.genderLabel.text = gender
      })
      actions.append(action)
    }
    
    genderChangeButton.menu = UIMenu(title: "성별", children: actions)
    genderChangeButton.showsMenuAsPrimaryAction = true
  }
}

extension String {
  func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
    var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    for index in 0 ..< pattern.count {
      guard index < pureNumber.count else { return pureNumber }
      let stringIndex = String.Index(utf16Offset: index, in: pattern)
      let patternCharacter = pattern[stringIndex]
      guard patternCharacter != replacementCharacter else { continue }
      pureNumber.insert(patternCharacter, at: stringIndex)
    }
    return pureNumber
  }
}
