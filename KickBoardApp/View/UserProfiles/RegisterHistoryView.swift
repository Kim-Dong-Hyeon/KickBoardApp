//
//  RegisterHistoryView.swift
//  KickBoardApp
//
//  Created by 김윤홍 on 7/22/24.
//

import UIKit

import SnapKit

class RegisterHistoryView: UIView {
  
  lazy var historyView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    collectionView.backgroundColor = .gray
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(historyView)
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setConstraints() {
    historyView.snp.makeConstraints {
      $0.edges.equalTo(self.safeAreaLayoutGuide).inset(10)
    }
  }
}
