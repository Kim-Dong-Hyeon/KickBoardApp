//
//  TabBarContorller.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/22/24.
//

import UIKit

class TabBarContorller: UITabBarController {
  
  private var mapControllerInstance: MapController?
  
  lazy var homeController: UINavigationController = {
    let controller = HomeController()
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController.tabBarItem.image = UIImage(systemName: "house")
    navigationController.tabBarItem.title = "Home"
    return navigationController
  }()
  
  lazy var registerKickboardController: UINavigationController = {
    let controller = UINavigationController(rootViewController: RegisterKickboardController())
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    controller.view.backgroundColor = .white
    return controller
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
}

//import UIKit
//
//class TabBarContorller: UITabBarController {
//  lazy var mapController = {
//    let controller = MapController()
//    controller.tabBarItem.image = UIImage(systemName: "house")
//    controller.tabBarItem.title = "Home"
//    controller.view.backgroundColor = .white
//    return controller
//  }()
//
//  lazy var registerKickboardController = {
//    let controller = UINavigationController(rootViewController: RegisterKickboardController())
//    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
//    controller.view.backgroundColor = .white
//    return controller
//  }()
//
//  lazy var myPageController = {
//    let controller = MypageController()
//    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
//    return controller
//  }()
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    let navigationController = UINavigationController(rootViewController: MypageController())
//    let naviCon = UINavigationController(rootViewController: HomeController())
//    navigationController.navigationBar.prefersLargeTitles = true
//    viewControllers = [naviCon, registerKickboardController, navigationController]
//  }
//}
