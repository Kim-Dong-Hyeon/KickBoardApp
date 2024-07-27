//
//  AddressFetcher.swift
//  KickBoardApp
//
//  Created by pc on 7/26/24.
//

import Foundation
import CoreLocation

import Alamofire

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
  // 현재 위치를 기반으로 주소를 가져오는 메서드
  func fetchAddress(latitude: Double, longitude: Double, completion: @escaping (String?, Error?) -> Void) {    
    guard let kakaoDevApiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_DEV_API_KEY") as? String else { return }
    
    let url = "https://dapi.kakao.com/v2/local/geo/coord2address"
    let parameters: [String: Any] = [
      "x": "\(longitude)",
      "y": "\(latitude)"
    ]
    let headers: HTTPHeaders = [
      "Authorization": "KakaoAK \(kakaoDevApiKey)"
    ]
    
    AF.request(url, method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: AddressResponse.self) { response in
        switch response.result {
        case .success(let addressResponse):
          print("-----\(addressResponse)")
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
