//
//  RegisterCell.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/23/24.
//

import UIKit

class RegisterCell: UICollectionViewCell {
  let dataManager = DataManager()
  static let identifier = "registerCell"
  
  private lazy var kickBoardImage: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .gray
    return imageView
  }()
  
  private lazy var addressLabel: UILabel = {
    let label = UILabel()
    label.text = "주소: "
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "위치: "
    return label
  }()
  
  private lazy var modelName: UILabel = {
    let label = UILabel()
    label.text = "모델명: "
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  private lazy var labelStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 5
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setConstraints()
    setupShadowAndCornerRadius()
    self.backgroundColor = UIColor(red: 12/255, green: 97/255, blue: 254/255, alpha: 1.0)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI() {
    [kickBoardImage, labelStackView].forEach { contentView.addSubview($0) }
    [modelName, addressLabel, dateLabel].forEach { labelStackView.addArrangedSubview($0) }
  }
  
  private func setupShadowAndCornerRadius() {
    contentView.layer.cornerRadius = 10.0
    contentView.layer.masksToBounds = true
    layer.cornerRadius = 13.0
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 4.0
  }
  
  private func setConstraints() {
    kickBoardImage.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(170)
    }
    
    labelStackView.snp.makeConstraints {
      $0.top.equalTo(kickBoardImage.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(kickBoardImage)
    }
  }
  
  func configureCell(with kickBoard: KickBoard) {
    modelName.text = "모델명: \(kickBoard.modelName ?? "")"
    addressLabel.text = "주소: \(kickBoard.registedLocation ?? "")"
    dateLabel.text = "날짜 : \(kickBoard.expirationDate ?? "")"
    if let imageData = kickBoard.imageData {
      kickBoardImage.image = UIImage(data: imageData)
    } else {
      kickBoardImage.image = nil
    }
  }
}
