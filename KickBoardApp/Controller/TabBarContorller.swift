//
//  TabBarContorller.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/22/24.
//

import UIKit

class TabBarContorller: UITabBarController {
  
  private var mapControllerInstance = MapController()
  
  lazy var homeController: UINavigationController = {
    let controller = HomeController()
    controller.mapController = mapControllerInstance
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.tabBarItem.image = UIImage(systemName: "house")
    navigationController.tabBarItem.title = "킥보드 찾기"
    return navigationController
  }()
  
  lazy var registerKickboardController: UINavigationController = {
    let controller = RegisterKickboardController()
    controller.mapController = mapControllerInstance
    let navigationController = UINavigationController(rootViewController: (controller))
    navigationController.tabBarItem.image = UIImage(systemName: "person.fill")
    navigationController.tabBarItem.title = "킥보드 등록"
    controller.view.backgroundColor = .white
    return navigationController
  }()
  
  lazy var myPageController: UINavigationController = {
    let controller = MypageController()
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.tabBarItem.image = UIImage(systemName: "person.fill")
    navigationController.tabBarItem.title = "마이페이지"
    return navigationController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = [homeController, registerKickboardController, myPageController]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapControllerInstance.restoreMapState()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mapControllerInstance.saveMapState()
  }
}
