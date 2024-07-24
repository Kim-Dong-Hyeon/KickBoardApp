//
//  MapView.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import UIKit

import KakaoMapsSDK
import SnapKit

class MapView: UIView {
  
  var mapContainer: KMViewContainer = {
    let container = KMViewContainer()
    container.backgroundColor = .white
    return container
  }()
  let currentLocationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "track_location_btn.png"), for: .normal)
    button.backgroundColor = .clear
    button.layer.cornerRadius = 25 // 반지름을 절반으로 설정하여 버튼을 원형으로 만듭니다.
    button.clipsToBounds = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  private func setupViews() {
    [
      mapContainer,
      currentLocationButton
    ].forEach { self.addSubview($0) }
    
    mapContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    currentLocationButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(100)
      $0.width.height.equalTo(50)
    }
  }
  
  func showToast(message: String, duration: TimeInterval = 2.0) {
    let toastLabel = UILabel()
    toastLabel.backgroundColor = UIColor.black
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds  =  true
    
    addSubview(toastLabel)
    toastLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-100)
      $0.width.equalTo(300)
      $0.height.equalTo(35)
    }
    
    UIView.animate(withDuration: 0.4,
                   delay: duration - 0.4,
                   options: .curveEaseOut,
                   animations: {
      toastLabel.alpha = 0.0
    },
                   completion: { _ in
      toastLabel.removeFromSuperview()
    })
  }
}
