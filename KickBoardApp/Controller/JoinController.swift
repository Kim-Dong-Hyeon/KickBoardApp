//
//  JoinController.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit
import CoreData

class JoinController: UIViewController, UITextFieldDelegate {
  
  let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  
  var joinView: JoinView!
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureEvent()
    // 전화번호 패턴 표시 적용을 위한 delegate 설정
    joinView.phoneNumberField.delegate = self
  }
  
  // 키보드 닫기
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  private func configureView() {
    joinView = JoinView(frame: UIScreen.main.bounds)
    self.view = joinView
    self.navigationItem.title = "회원가입"
  }
  
  private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
    // 전화번호 형식을 정의한 정규식 패턴
    let regex = #"^\d{3}-\d{4}-\d{4}$"#
    // 일치하면 일치하는 부분을 리턴함 일치하는 부분이 없으면 nil return
    return phoneNumber.range(of: regex, options: .regularExpression) == nil
  }
  
  private func configureEvent() {
    joinView.joinButton.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.joinUser()
    }, for: .touchDown)
  }
  
  private func userDataCreate() {
    guard let entity = NSEntityDescription.entity(forEntityName: User.className, in: container.viewContext) else { return }
    let newUser = NSManagedObject(entity: entity, insertInto: container.viewContext)
    newUser.setValue(joinView.idField.text, forKey: User.Key.id)
    newUser.setValue(joinView.pwdChkField.text, forKey: User.Key.password)
    newUser.setValue(joinView.nameField.text, forKey: User.Key.name)
    newUser.setValue(joinView.genderLabel.text, forKey: User.Key.gender)
    newUser.setValue(joinView.phoneNumberField.text, forKey: User.Key.phoneNumber)
    newUser.setValue("일반회원", forKey: User.Key.memberType)
    newUser.setValue(false, forKey: User.Key.state)
    
    do {
      try container.viewContext.save()
      self.navigationController?.popViewController(animated: true)
      customAlert(msg: "회원가입이 완료 되었습니다.")
      print("생성 성공")
    } catch {
      print("생성 실패")
    }
  }
  
  private func joinUser() {
    let alert = UIAlertController(title: "회원가입", message: "입력하신 정보로\n회원가입 하시겠습니까?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "취소", style: .default) { _ in
      return
    })
    alert.addAction(UIAlertAction(title: "확인", style: .default) { [self] _ in
      if !idCheck() {
        return
      } else if !pwdCheck() {
        return
      } else if let name = joinView.nameField.text, name.count == 0 {
        customAlert(msg: "이름을 입력해 주세요.")
      } else if let phoneNumber = joinView.phoneNumberField.text, validatePhoneNumber(phoneNumber) {
        customAlert(msg: "전화번호 형식을 확인해 주세요.\n(000-0000-0000)")
      } else {
        self.userDataCreate()
      }
    })
    self.present(alert, animated: true, completion: nil)
  }
  
  private func userSelectDataRead(id: String) -> Bool {
    do {
      let request = User.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", id)
      // 속성으로 데이터 정렬해서 가져오기
      let user = try container.viewContext.fetch(request)
      print("조건 불러오기 성공")
      return user.count == 0 ? true : false
    } catch {
      print("조건 불러오기 실패")
    }
    return false
  }
  
  private func customAlert(msg: String) {
    let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
      return
    })
    self.present(alert, animated: true, completion: nil)
  }
  
  private func idCheck() -> Bool {
    if joinView.idField.text == nil {
      customAlert(msg: "아이디를 입력해 주세요")
      return false
    } else if let id = joinView.idField.text, !userSelectDataRead(id: id) {
      customAlert(msg: "중복된 아이디입니다.")
      return false
    } else {
      return true
    }
  }
  
  private func pwdCheck() -> Bool {
    if joinView.pwdField.text == nil {
      customAlert(msg: "비밀번호를 입력해 주세요")
      return false
    } else if joinView.pwdChkField.text == nil {
      customAlert(msg: "비밀번호를 다시한번 입력해 주세요.")
      return false
    } else if let pwd = joinView.pwdField.text,
              let pwdCh = joinView.pwdChkField.text, pwd != pwdCh {
      customAlert(msg: "비밀번호가 일치하지 않습니다.")
      return false
    } else {
      return true
    }
  }
  
  // UITextFieldDelegate 메서드
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == joinView.phoneNumberField {
      let currentText = textField.text ?? ""
      let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
      let newStringWithoutDashes = newString.replacingOccurrences(of: "-", with: "")
      
      // 입력된 숫자가 11글자를 넘으면 입력을 막음
      if newStringWithoutDashes.count > 11 {
        return false
      }
      
      textField.text = newString.applyPatternOnNumbers(pattern: "###-####-####", replacementCharacter: "#")
      return false
    }
    return true
  }
}
