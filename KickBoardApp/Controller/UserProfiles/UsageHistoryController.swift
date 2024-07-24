//
//  UsageHistoryController.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class UsageHistoryController: UIViewController {
  
  lazy var usageList = UITableView()

  override func viewDidLoad() {
    self.title = "나의 이용 내역"
    view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    view.addSubview(usageList)
    setupTableView()
  }
  
  func setupTableView() {
    usageList.delegate = self
    usageList.dataSource = self
    usageList.register(UsageListCell.self, forCellReuseIdentifier: UsageListCell.identifier)
    usageList.rowHeight = 180
    usageList.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
}

extension UsageHistoryController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usageList.dequeueReusableCell(withIdentifier: UsageListCell.identifier, for: indexPath) as? UsageListCell
    else { return UITableViewCell() }
    
    return cell
  }
}
