//
//  MypageController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

class MypageController: UIViewController {
  
  var myPageView: MyPageView!
  
  override func loadView() {
    myPageView = MyPageView(frame: UIScreen.main.bounds)
    self.view = myPageView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.myPageView.backgroundColor = .systemBackground
    self.navigationItem.title = "마이페이지"
    self.navigationItem.largeTitleDisplayMode = .automatic
    setUpTableView()
  }
  
  func setUpTableView() {
    myPageView.myPageList.dataSource = self
    myPageView.myPageList.delegate = self
    myPageView.myPageList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
}

extension MypageController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = indexPath.row == 0 ? "나의 이용 내역" : "나의 등록 내역"
    cell.contentConfiguration = content
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controllerArray = [UsageHistoryController(), RegisterHistoryController()]
    self.navigationController?.pushViewController(controllerArray[indexPath.row], animated: true)
  }
}

