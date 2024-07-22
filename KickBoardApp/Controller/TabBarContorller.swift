//
//  TabBarContorller.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/22/24.
//

import UIKit

class TabBarContorller: UITabBarController {
  lazy var homeController = {
    let controller = ViewController()
    controller.tabBarItem.image = UIImage(systemName: "house")
    controller.view.backgroundColor = .white
    return controller
  }()
  
  lazy var secondController = {
    let controller = ViewController()
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    controller.view.backgroundColor = .red
    return controller
  }()
  
  lazy var thirdController = {
    let controller = ViewController()
    controller.tabBarItem.image = UIImage(systemName: "play.house.fill")
    controller.view.backgroundColor = .blue
    return controller
  }()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewControllers = [homeController, secondController, thirdController]
  }
}
