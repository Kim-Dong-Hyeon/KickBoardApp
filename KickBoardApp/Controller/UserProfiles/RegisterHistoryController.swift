//
//  RegisterHistory.swift
//
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

class RegisterHistoryController: UIViewController {
  
  var registerHistory: RegisterHistoryView!
  let dataManager = DataManager()
  var models: [KickBoard] = [] {
    didSet {
      registerHistory.historyView.reloadData()
    }
  }
  override func loadView() {
    registerHistory = RegisterHistoryView(frame: UIScreen.main.bounds)
    self.view = registerHistory
  }
  
  override func viewDidLoad() {
    self.title = "나의 등록 내역"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    view.backgroundColor = .white
    registerHistory.historyView.dataSource = self
    registerHistory.historyView.delegate = self
    registerHistory.historyView.register(RegisterCell.self, forCellWithReuseIdentifier: RegisterCell.identifier)
  }
}

extension RegisterHistoryController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisterCell.identifier, for: indexPath) as? RegisterCell else {
      return UICollectionViewCell()
    }
    return cell
  }
}

extension RegisterHistoryController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let padding: CGFloat = 20
    let spacing: CGFloat = 10
    let width = collectionView.frame.width - padding - spacing
    let cellWidth = width / 2
    return CGSize(width: cellWidth, height: 300)
  }
}
