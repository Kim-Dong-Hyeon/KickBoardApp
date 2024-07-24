//
//  UsageHistoryController.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class UsageHistoryController: UIViewController {
  
  lazy var usageList = UITableView(frame: .zero, style: .insetGrouped)
  let dataManager = DataManager()
  var models: [Ride] = [] {
    didSet {
      usageList.reloadData()
    }
  }
  override func viewDidLoad() {
    self.title = "나의 이용 내역"
    view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    view.addSubview(usageList)
    setupTableView()
//    models = dataManager.readCoreData(entityType: Ride.self).filter { $0.registrant == dataManager.readUserDefault(key: "userName")}
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
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usageList.dequeueReusableCell(withIdentifier: UsageListCell.identifier, for: indexPath) as? UsageListCell
    else { return UITableViewCell() }
    
//    let ride = models[indexPath.row]
//    cell.configureCell(with: ride)
    return cell
  }
  
  // 셀 간의 간격을 설정하기 위해 푸터 뷰의 높이를 설정
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 10 // 셀 간의 간격
  }

  // 푸터 뷰를 빈 뷰로 설정하여 셀 간의 간격을 적용
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView()
    footerView.backgroundColor = UIColor.clear // 빈 뷰 반환
    return footerView
  }
}
