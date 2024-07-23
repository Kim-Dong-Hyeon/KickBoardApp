//
//  EditController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

class JoinController: UIViewController {
  
  var joinView: JoinView!
  
  override func viewDidLoad() {
//    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    joinView = JoinView(frame: UIScreen.main.bounds)
    self.view = joinView
    self.navigationItem.title = "회원가입"
  }
}

