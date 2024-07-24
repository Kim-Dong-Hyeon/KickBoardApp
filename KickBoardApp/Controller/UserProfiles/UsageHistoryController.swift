//
//  UsageHistoryController.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

class UsageHistoryController: UIViewController {
  
  var usageHistoryView: UsageHistoryView!
  
  override func loadView() {
    usageHistoryView = UsageHistoryView(frame: UIScreen.main.bounds)
    self.view = usageHistoryView
  }
  override func viewDidLoad() {
    self.title = "나의 이용 내역"
    view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    usageHistoryView.usageList.delegate = self
    usageHistoryView.usageList.dataSource = self
    usageHistoryView.usageList.register(UsageListCell.self, forCellReuseIdentifier: UsageListCell.identifier)
  }
}

extension UsageHistoryController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usageHistoryView.usageList.dequeueReusableCell(withIdentifier: UsageListCell.identifier, for: indexPath) as? UsageListCell
    else { return UITableViewCell() }
    
    return cell
  }
}
