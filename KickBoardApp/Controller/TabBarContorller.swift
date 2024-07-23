//
//  TabBarContorller.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/22/24.
//

import UIKit

class TabBarContorller: UITabBarController {
  lazy var mapController = {
    let controller = MapController()
    controller.tabBarItem.image = UIImage(systemName: "house")
    controller.tabBarItem.title = "Home"
    controller.view.backgroundColor = .white
    return controller
  }()
  
  lazy var registerKickboardController = {
    let controller = UINavigationController(rootViewController: RegisterKickboardController())
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    controller.view.backgroundColor = .white
    return controller
  }()
  
  lazy var myPageController = {
    let controller = MypageController()
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    return controller
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let navigationController = UINavigationController(rootViewController: MypageController())
    let naviCon = UINavigationController(rootViewController: HomeController())
    navigationController.navigationBar.prefersLargeTitles = true
    viewControllers = [mapController, registerKickboardController, navigationController]
  }
}
