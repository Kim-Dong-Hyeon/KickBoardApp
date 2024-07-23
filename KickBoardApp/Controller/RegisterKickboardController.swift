//
//  RegisterKickboardController.swift
//  KickBoardApp
//
//  Created by pc on 7/22/24.
//

import Foundation
import UIKit
class RegisterKickboardController: UIViewController {
  var registerKickboardView: RegisterKickboardView!
  override func loadView() {
    registerKickboardView = RegisterKickboardView(frame: UIScreen.main.bounds)
    self.view = registerKickboardView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerKickboardView.backgroundColor = .systemBackground
    self.title = "킥보드 등록"
    
  }
}
