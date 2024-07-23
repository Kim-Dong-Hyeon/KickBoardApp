//
//  TabBarContorller.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/22/24.
//

import UIKit

class TabBarContorller: UITabBarController {
  lazy var homeController = {
    let controller = HomeController()
    controller.tabBarItem.image = UIImage(systemName: "house")
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
    navigationController.navigationBar.prefersLargeTitles = true
    viewControllers = [homeController, registerKickboardController, navigationController]
  }
}
