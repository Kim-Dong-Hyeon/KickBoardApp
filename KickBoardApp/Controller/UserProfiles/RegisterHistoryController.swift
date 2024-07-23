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
  
  override func loadView() {
    registerHistory = RegisterHistoryView(frame: UIScreen.main.bounds)
    self.view = registerHistory
    self.title = "나의 등록 내역"
    self.navigationItem.largeTitleDisplayMode = .automatic
  }
  
  override func viewDidLoad() {
    registerHistory.historyView.dataSource = self
    registerHistory.historyView.delegate = self
    registerHistory.historyView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UsageListCell")
  }
}

extension RegisterHistoryController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    UICollectionViewCell()
  }
}
