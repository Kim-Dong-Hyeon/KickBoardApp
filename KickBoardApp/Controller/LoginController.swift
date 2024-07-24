//
//  EditController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

class LoginController: UIViewController {
  
  let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
  var loginView: LoginView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    
    loginView.loginButton.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.loginProc()
    }, for: .touchDown)
  }
  
  private func joinViewPush() {
    let joinController = JoinController()
    self.navigationController?.pushViewController(joinController, animated: true)
  }
  
  private func loginProc() {
    do {
      guard let id = loginView.idField.text else { return }
      let request = User.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id)
      // 속성으로 데이터 정렬해서 가져오기
      let idChk = try container.viewContext.fetch(request)
      if idChk.isEmpty {
        customAlert(msg: "존재하지 않는 아이디입니다.")
        return
      } else {
        guard let pwd = loginView.pwdField.text else { return }
        request.predicate = NSPredicate(format: "password == %@", pwd)
        let pwdChk = try container.viewContext.fetch(request)
        if pwdChk.isEmpty {
          customAlert(msg: "비밀번호가 틀렸습니다.")
        } else {
          let defaults = UserDefaults.standard
          defaults.set(id, forKey: "userName")
          let homeController = TabBarContorller()
          homeController.modalPresentationStyle = .fullScreen
          self.present(homeController, animated: true, completion: nil)
        }
      }
      print("조건 불러오기 성공")
    } catch {
      print("조건 불러오기 실패")
    }
  }
  
  private func customAlert(msg: String) {
    let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
      return
    })
    self.present(alert, animated: true, completion: nil)
  }
  
  private func moveToTabBarController() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      let tabBarController = TabBarContorller()
      window.rootViewController = tabBarController
      window.makeKeyAndVisible()
    }
    
//    let homeController = TabBarContorller()
//    homeController.modalPresentationStyle = .fullScreen
//    self.present(homeController, animated: true, completion: nil)
  }
}
