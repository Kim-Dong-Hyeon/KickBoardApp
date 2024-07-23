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
    controller.tabBarItem.title = "Home"
    controller.view.backgroundColor = .white
    return controller
  }()
  
  lazy var editController = {
    let controller = EditController()
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    controller.view.backgroundColor = .red
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
    viewControllers = [naviCon, editController, navigationController]
  }
}
