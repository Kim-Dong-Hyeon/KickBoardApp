//
//  EditController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

class LoginController: UIViewController {
  
  var loginView: LoginView!
  
  override func viewDidLoad() {
//    super.viewDidLoad()
    configureView()
    configureEvent()
  }
  
  private func configureView() {
    loginView = LoginView(frame: UIScreen.main.bounds)
    self.view = loginView
  }
  
  private func configureEvent() {
    loginView.joinButton.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.joinViewPush()
    }, for: .touchDown)
  }
  
  private func joinViewPush() {
    let joinController = JoinController()
    self.navigationController?.pushViewController(joinController, animated: true)
  }
}

//protocol LoginViewDelegate {
//  func joinViewPush()
//}
//
//extension LoginController: LoginViewDelegate {
//  func joinViewPush() {
//    let joinController = JoinController()
//    self.navigationController?.pushViewController(joinController, animated: true)
//  }
//}

