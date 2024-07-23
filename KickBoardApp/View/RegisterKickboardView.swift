//
//  RegisterKickboardView.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import UIKit
import SnapKit

class RegisterKickboardView: UIView {
  let adressLabel: UILabel = {
    let label = UILabel()
    label.text = "주소: "
    return label
  }()
  let registrantLabel: UILabel = {
    let label = UILabel()
    label.text = "등록자: "
    return label
  }()
  let modelNameLabel: UILabel = {
    let label = UILabel()
    label.text = "모델명:"
    return label
  }()
  let modelNameTextField: UITextField = {
    let textField = UITextField()
    textField.text = ""
    textField.borderStyle = .roundedRect
    return textField
  }()
  let rentalPeriodLabel: UILabel = {
    let label = UILabel()
    label.text = "대여 기간"
    label.textAlignment = .center
    return label
  }()
  let currentDateLabel: UILabel = {
    let label = UILabel()
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.locale = Locale(identifier: "ko-KR")
    label.text = dateFormatter.string(from: currentDate)
    label.font = UIFont.systemFont(ofSize: 18)
    return label
  }()
  let retalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 16
    return stackView
  }()
  let rentalPeriodDatePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .automatic
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.timeZone = .autoupdatingCurrent
    return datePicker
  }()
  let registerButton: AnimationButton = {
    let button = AnimationButton()
    button.setTitle("등록", for: .normal)
    return button
  }()
  let cancelButton: AnimationButton = {
    let button = AnimationButton()
    button.setTitle("취소", for: .normal)
    return button
  }()
  
  let modelNameStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    return stackView
  }()
  let registerInformationStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    return stackView
  }()
  let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 16
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI() {
    [
      registerInformationStackView,
      buttonStackView
    ].forEach { self.addSubview($0) }
    
    [
      modelNameLabel,
      modelNameTextField
    ].forEach {
      modelNameStackView.addArrangedSubview($0)
    }
    [
    currentDateLabel,
    rentalPeriodDatePicker
    ].forEach {
      retalStackView.addArrangedSubview($0)
    }
    
    [
      adressLabel,
      registrantLabel,
      modelNameStackView,
      rentalPeriodLabel,
      retalStackView
    ].forEach {
      registerInformationStackView.addArrangedSubview($0)
    }
    
    [
      registerButton,
      cancelButton
    ].forEach {
      $0.tintColor = .white
      $0.layer.cornerRadius = 5
      $0.backgroundColor = .blue
      buttonStackView.addArrangedSubview($0)
    }
  }
  
  func setConstraints() {
    buttonStackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(120)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(300)
      $0.height.equalTo(40)
    }
    
    registerInformationStackView.snp.makeConstraints {
      $0.bottom.equalTo(buttonStackView.snp.top).offset(-30)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.7)
    }
    
    modelNameTextField.snp.makeConstraints {
      $0.width.equalTo(200)
    }
  }
}
