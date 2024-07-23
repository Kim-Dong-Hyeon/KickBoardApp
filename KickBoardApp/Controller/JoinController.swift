//
//  EditController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

class JoinController: UIViewController {
  let genderArr: [String] = ["남자", "여자"]
  
  var joinView: JoinView!
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    //    super.viewDidLoad()
    configureView()
    configureGenderMenu()
  }
  
  private func configureView() {
    joinView = JoinView(frame: UIScreen.main.bounds)
    self.view = joinView
    self.navigationItem.title = "회원가입"
  }
  
  private func configureGenderMenu() {
    var actions: [UIAction] = []
    for gender in genderArr {
        let action = UIAction(title: gender, handler: { [weak self] (action) in
          guard let self = self else { return }
          self.joinView.genderLabel.text = gender
        })
        actions.append(action)
    }
    
    DispatchQueue.main.async {
      self.joinView.genderChangeButton.menu = UIMenu(title: "성별", children: actions)
      self.joinView.genderChangeButton.showsMenuAsPrimaryAction = true
    }
  }
}
