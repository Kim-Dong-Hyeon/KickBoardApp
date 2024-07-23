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
    imageView.backgroundColor = .gray
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
  
  private lazy var id: UILabel = {
    let label = UILabel()
    label.text = "id"
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
    configureUI()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    [cellImage, cellStackView].forEach { contentView.addSubview($0) }
    [id, depature, arrival, fee].forEach { cellStackView.addArrangedSubview($0) }
  }
  
  private func setConstraints() {
    cellImage.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(10)
      $0.top.equalTo(cellStackView.snp.top)
      $0.width.height.equalTo(50)
    }
    
    cellStackView.snp.makeConstraints {
      $0.leading.equalTo(cellImage.snp.trailing).offset(10)
    }
  }
}
