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
    navigationController.tabBarItem.title = "Home"
    return navigationController
  }()
  
  lazy var registerKickboardController: UINavigationController = {
    let controller = RegisterKickboardController()
    controller.mapController = mapControllerInstance
    let navigationController = UINavigationController(rootViewController: (controller))
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    controller.view.backgroundColor = .white
    return navigationController
  }()
  
  lazy var myPageController: UINavigationController = {
    let controller = MypageController()
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.tabBarItem.image = UIImage(systemName: "play.house.fill")
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
