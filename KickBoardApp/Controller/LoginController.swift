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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let defaults = UserDefaults.standard
    if defaults.string(forKey: "userName") == nil {
      return
    } else {
      moveToTabBarController()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  // 키보드 닫기
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
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
          moveToTabBarController()
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
  
  // 키보드 올라오면 View 올려주기 구현
  @objc func keyboardUp(notification:NSNotification) {
    if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      
      UIView.animate(
        withDuration: 0.3
        , animations: {
          self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height/3)
        }
      )
    }
  }
  
  @objc func keyboardDown() {
    self.view.transform = .identity
  }
}
