//
//  UsageHistoryController.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class UsageHistoryController: UIViewController {
  
  let mapController = MapController()
  lazy var usageList = UITableView(frame: .zero, style: .insetGrouped)
  let dataManager = DataManager()
  var models: [Ride] = [] {
    didSet {
      usageList.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    models = dataManager.readCoreData(entityType: Ride.self).filter { $0.name == dataManager.readUserDefault(key: "userName")}
    usageList.reloadData()
  }
  
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
    usageList.separatorStyle = .none
    usageList.backgroundColor = .white
    usageList.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
}

extension UsageHistoryController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UsageListCell.identifier, for: indexPath) as? UsageListCell else {
      return UITableViewCell()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView()
    footerView.backgroundColor = .clear
    return footerView
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 10 }
}
