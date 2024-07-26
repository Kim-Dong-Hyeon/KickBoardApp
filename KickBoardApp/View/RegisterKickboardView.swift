//
//  RegisterKickboardView.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import UIKit
import SnapKit

class RegisterKickboardView: UIView {

  let mapView: UIView = {
    let view = UIView()
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.cornerRadius = 5.0
    view.clipsToBounds = true
    return view
  }()
  let currentLocationButton: AnimationButton = {
    let button = AnimationButton()
    button.setImage(UIImage(named: "track_location_btn"), for: .normal)
    button.backgroundColor = .clear
    return button
  }()
  let adressLabel: UILabel = {
    let label = UILabel()
    label.attributedText = NSAttributedString(string: "위 치", attributes: [.kern: 4.9])
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(named: "KickColor")
    return label
  }()
  let adressValue: UILabel = {
    let label = UILabel()
    label.text = ""
    label.font = .systemFont(ofSize: 15)
    label.textAlignment = .right
    label.numberOfLines = 1
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  let adressStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 2
    return stackView
  }()
  
  let registrantLabel: UILabel = {
    let label = UILabel()
    label.text = "등록자"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(named: "KickColor")
    return label
  }()
  let registrantValue: UILabel = {
    let label = UILabel()
    label.text = ""
    label.textAlignment = .right
    return label
  }()
  let registrantStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()
  
  let modelNameLabel: UILabel = {
    let label = UILabel()
    label.text = "모델명"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(named: "KickColor")
    return label
  }()
  let modelNameTextField: UITextField = {
    let textField = UITextField()
    textField.text = ""
    textField.borderStyle = .roundedRect
    textField.textAlignment = .right
    return textField
  }()
  let modelNameStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()
  
  let rentalPeriodLabel: UILabel = {
    let label = UILabel()
    label.text = "대여 기간"
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(named: "KickColor")
    return label
  }()
  let currentDateLabel: UILabel = {
    let label = UILabel()
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy. MM. dd"
    label.text = dateFormatter.string(from: currentDate)
    label.font = UIFont.systemFont(ofSize: 15)
    label.textAlignment = .right
    return label
  }()
  let rentalStackView1: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 2
    return stackView
  }()
  let waveLabel: UILabel = {
    let label = UILabel()
    label.text = "~    "
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 15)
    return label
  }()
  let rentalPeriodDatePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .automatic
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.timeZone = .autoupdatingCurrent
    datePicker.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    return datePicker
  }()
  let rentalStackView2: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 2
    return stackView
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
  let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 40
    return stackView
  }()
 
  let registerInformationStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 17
    return stackView
  }()
  
  let PhotoView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .gray
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 5
    return imageView
  }()
  let selectPhotoButton: AnimationButton = {
    let button = AnimationButton()
    button.setTitle("사진 선택", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    button.backgroundColor = .white
    button.setTitleColor(.gray, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.systemGray4.cgColor
    button.layer.cornerRadius = 5
    return button
  }()
  let addPhotoStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  let aStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
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
    [mapView, aStackView, buttonStackView,currentLocationButton].forEach { self.addSubview($0)}
    [adressLabel, adressValue].forEach { 
        adressStackView.addArrangedSubview($0) }
    [registrantLabel, registrantValue].forEach { registrantStackView.addArrangedSubview($0) }
    [modelNameLabel, modelNameTextField].forEach { modelNameStackView.addArrangedSubview($0) }
    [rentalPeriodLabel ,currentDateLabel].forEach { rentalStackView1.addArrangedSubview($0) }
    [rentalStackView1, waveLabel, rentalPeriodDatePicker].forEach { rentalStackView2.addArrangedSubview($0) }
    [PhotoView, selectPhotoButton].forEach { addPhotoStackView.addArrangedSubview($0) }
    [adressStackView, registrantStackView, modelNameStackView, rentalStackView2].forEach {
      registerInformationStackView.addArrangedSubview($0)
    }
    [addPhotoStackView, registerInformationStackView].forEach { aStackView.addArrangedSubview($0) }
    [registerButton, cancelButton].forEach {
      $0.layer.cornerRadius = 10
      $0.backgroundColor = UIColor(named: "KickColor")
      $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
      buttonStackView.addArrangedSubview($0)
    }
  }
  
  func setConstraints() {
    currentLocationButton.snp.makeConstraints {
      $0.bottom.equalTo(mapView.snp.bottom).inset(25)
      $0.trailing.equalTo(mapView.snp.trailing).inset(25)
      $0.width.height.equalTo(30)
    }
    mapView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.leading.equalToSuperview().inset(30)
      $0.trailing.equalToSuperview().inset(30)
      $0.bottom.equalTo(aStackView.snp.top).inset(-30)
    }
    adressLabel.snp.makeConstraints {
      $0.trailing.equalTo(registrantLabel.snp.trailing)
    }
    modelNameLabel.snp.makeConstraints {
      $0.width.equalTo(60)
    }
    addPhotoStackView.snp.makeConstraints {
      $0.width.equalTo(120)
    }
    selectPhotoButton.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    rentalPeriodDatePicker.snp.makeConstraints {
      $0.trailing.equalToSuperview()
    }
    modelNameTextField.snp.makeConstraints {
      $0.height.equalTo(25)
    }
    buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(90)
      $0.height.equalTo(46)
      $0.width.equalTo(320)
//      $0.bottom.equalToSuperview().inset(90)
//      $0.centerX.equalToSuperview()
//      $0.width.equalTo(300)
//      $0.height.equalTo(50)
    }
    aStackView.snp.makeConstraints {
      $0.height.equalTo(200)
      $0.bottom.equalTo(buttonStackView.snp.top).offset(-20)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().inset(30)
      $0.trailing.equalToSuperview().inset(30)
//      $0.width.equalToSuperview().multipliedBy(0.8)
    }
  }
}
