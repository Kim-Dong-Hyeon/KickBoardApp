//
//  MypageController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

class MypageController: UIViewController {
  
  var myPageView: MyPageView!
  let dataManager = DataManager()
  
  override func loadView() {
    myPageView = MyPageView(frame: UIScreen.main.bounds)
    self.view = myPageView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "마이페이지"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    self.myPageView.backgroundColor = .white
    self.navigationItem.largeTitleDisplayMode = .automatic
    myPageView.moveHistoryList.addTarget(
      self,
      action: #selector(registerTapped),
      for: .touchUpInside
    )
    myPageView.moveUsageList.addTarget(self, action: #selector(usageTapped), for: .touchUpInside)
    myPageView.logOut.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    myPageView.getData()
  }
  
  @objc func logOutTapped() {
    dataManager.deleteUserDefault(key: "userName")
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = scene.windows.first {
      window.rootViewController = UINavigationController(rootViewController: LoginController())
    }
  }
  
  @objc func registerTapped() {
    self.navigationController?.pushViewController(RegisterHistoryController(), animated: true)
  }
  @objc func usageTapped() {
    self.navigationController?.pushViewController(UsageHistoryController(), animated: true)
  }
}

