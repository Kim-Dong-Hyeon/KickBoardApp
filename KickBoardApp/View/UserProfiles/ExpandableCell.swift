//
//  ExpandableCell.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/25/24.
//

import Foundation
import UIKit

class ExpandableCell: UITableViewCell {
  static let identifier = "ExpandableCell"
  
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
    [fee].forEach { contentView.addSubview($0) }
  }
  
  private func setConstraints() {
    fee.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
