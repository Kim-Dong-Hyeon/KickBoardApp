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
    self.navigationItem.largeTitleDisplayMode = .automatic
  }
}

extension UsageHistoryController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  
}
