//
//  Address.swift
//  KickBoardApp
//
//  Created by pc on 7/26/24.
//

import Foundation
import Alamofire
import CoreLocation
// Kakao API의 응답 JSON 구조에 맞게 모델 정의
struct AddressResponse: Decodable {
  let documents: [Document]
}

struct Document: Decodable {
  let address: Address
}

struct Address: Decodable {
  let addressName: String
  enum CodingKeys: String, CodingKey {
    case addressName = "address_name"
  }
}


class AddressFetcher {
  func fetchAddress(completion: @escaping (String?, Error?) -> Void) {
    guard let longitude = LocationManager.shared.currentLongitude,
          let latitude = LocationManager.shared.currentLatitude else {
      print("위치 정보를 가져올 수 없습니다.")
      return
    }
    
    let url = "https://dapi.kakao.com/v2/local/geo/coord2address"
    let parameters: [String: Any] = [
      "x": "\(longitude)",
      "y": "\(latitude)"
    ]
    let headers: HTTPHeaders = [
      "Authorization": "KakaoAK 6bd2f48c14bff7b12004d573320c3e75"
    ]
    
    AF.request(url, method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: AddressResponse.self) { response in
        switch response.result {
        case .success(let addressResponse):
          if let firstDocument = addressResponse.documents.first {
            completion(firstDocument.address.addressName, nil)
          }
        case .failure(let error):
          completion(nil, error)
          print("error: \(completion(nil, error))")
        }
      }
  }
}
