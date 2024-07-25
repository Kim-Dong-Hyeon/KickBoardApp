//
//  UsageHistoryController.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit
import SnapKit

class UsageHistoryController: UIViewController {
  
  var openSections: [Bool] = Array(repeating: false, count: 5)
  let value = 5
  lazy var usageList = UITableView(frame: .zero, style: .insetGrouped)
  let dataManager = DataManager()
  var models: [Ride] = [] {
    didSet {
      usageList.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
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
    usageList.register(ExpandableCell.self, forCellReuseIdentifier: ExpandableCell.identifier)
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
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return openSections[section] ? 2 : 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 5 // 고정된 섹션 수
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: UsageListCell.identifier, for: indexPath) as? UsageListCell else {
        return UITableViewCell()
      }
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableCell.identifier, for: indexPath) as? ExpandableCell else {
        return UITableViewCell()
      }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0 {
      openSections[indexPath.section].toggle()
      tableView.reloadSections([indexPath.section], with: .none)
    } else {
      print("Expandable cell 선택됨")
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView()
    footerView.backgroundColor = .clear
    return footerView
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 10
  }
}
