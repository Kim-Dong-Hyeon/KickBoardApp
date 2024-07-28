//
//  RegisterHistory.swift
//
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class RegisterHistoryController: UIViewController {
  
  lazy var historyView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  let dataManager = DataManager()
  var models: [KickBoard] = [] {
    didSet {
      historyView.reloadData()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    models = dataManager.readCoreData(entityType: KickBoard.self).filter {
      $0.registrant == dataManager.readUserDefault(key: "userName")
    }
    historyView.reloadData()
  }
  
  override func viewDidLoad() {
    self.title = "나의 등록 내역"
    view.addSubview(historyView)
    setHistoryView()
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    view.backgroundColor = .white
    historyView.register(RegisterCell.self, forCellWithReuseIdentifier: RegisterCell.identifier)
    models = dataManager.readCoreData(entityType: KickBoard.self).filter {
      $0.registrant == dataManager.readUserDefault(key: "userName")
    }
  }
  
  func setHistoryView() {
    historyView.dataSource = self
    historyView.delegate = self
    
    historyView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide).inset(15)
    }
  }
}

extension RegisterHistoryController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return models.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: RegisterCell.identifier, 
      for: indexPath
    ) as? RegisterCell else {
      return UICollectionViewCell()
    }
    let kickBoard = models[indexPath.row]
    cell.configureCell(with: kickBoard)
    return cell
  }
}

extension RegisterHistoryController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.frame.width
    let spacing = 10
    let cellWidth = Int(width) / 2 - spacing
    return CGSize(width: cellWidth, height: 300)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
}
