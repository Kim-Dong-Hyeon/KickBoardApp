//
//  UsageListCell.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/23/24.
//

import UIKit

class UsageListCell: UITableViewCell {
  static let identifier = "UsageListCell"
  
  private lazy var cellImage: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "testImage(Kickboard)")
    return imageView
  }()
  
  private lazy var cellStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.backgroundColor = .gray
    stackView.spacing = 5
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var userId: UILabel = {
    let label = UILabel()
    label.text = "user"
    label.font = .boldSystemFont(ofSize: 25)
    return label
  }()
  
  private lazy var modelName: UILabel = {
    let label = UILabel()
    label.text = "모델명 "
    return label
  }()
  
  private lazy var depature: UILabel = {
    let label = UILabel()
    label.text = "출발"
    return label
  }()
  
  private lazy var arrival: UILabel = {
    let label = UILabel()
    label.text = "도착"
    return label
  }()
  
  private lazy var fee: UILabel = {
    let label = UILabel()
    label.text = "요금"
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = UIColor(red: 12/255, green: 97/255, blue: 254/255, alpha: 1.0)
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    [cellImage, cellStackView, userId].forEach { contentView.addSubview($0) }
    [modelName, depature, arrival, fee].forEach { cellStackView.addArrangedSubview($0) }
  }
  
  private func setConstraints() {
    cellImage.snp.makeConstraints {
      $0.top.equalToSuperview().inset(10)
      $0.leading.equalToSuperview().inset(10)
      $0.width.height.equalTo(50)
    }
    
    userId.snp.makeConstraints {
      $0.leading.equalTo(cellStackView)
      $0.centerY.equalTo(cellImage.snp.centerY)
    }
    
    cellStackView.snp.makeConstraints {
      $0.top.equalTo(cellImage.snp.bottom)
      $0.leading.equalTo(cellImage.snp.trailing).offset(10)
      $0.trailing.equalToSuperview()
    }
  }
  
  func configureCell(with ride: Ride) {
    modelName.text = "모델명 \(String(describing: ride.name))"
    depature.text = "출발 \(String(describing: ride.startDate))"
    arrival.text = "도착 \(String(describing: ride.endDate))"
    fee.text = "요금 \(ride.price)원"
  }
}
