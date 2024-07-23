//
//  UsageHistoryView.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class UsageHistoryView: UIView {
  
  lazy var usageList = {
    let tableView = UITableView()
    tableView.backgroundColor = .green
    tableView.rowHeight = 100

    return tableView
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
    self.addSubview(usageList)
  }
  
  func setConstraints() {
    usageList.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide).inset(20)
    }
  }
}
