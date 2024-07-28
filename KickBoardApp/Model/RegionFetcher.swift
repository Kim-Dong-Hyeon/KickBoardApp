//
//  RegionFetcher.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/27/24.
//

import Foundation
import CoreLocation

import Alamofire

// Kakao API의 응답 JSON 구조에 맞게 모델 정의
struct RegionResponse: Decodable {
  let documents: [RegionDocument]
}

struct RegionDocument: Decodable {
  let regionType: String
  let addressName: String
  
  enum CodingKeys: String, CodingKey {
    case regionType = "region_type"
    case addressName = "address_name"
  }
}

class RegionFetcher {
  // 좌표를 기반으로 행정구역 정보를 가져오는 메서드
  func fetchRegion(longitude: Double, latitude: Double, completion: @escaping ([RegionDocument]?, Error?) -> Void) {
    guard let kakaoDevApiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_DEV_API_KEY") as? String else {
      print("Kakao API Key가 설정되어 있지 않습니다.")
      return
    }
    
    let url = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"
    let parameters: [String: Any] = [
      "x": "\(longitude)",
      "y": "\(latitude)"
    ]
    let headers: HTTPHeaders = [
      "Authorization": "KakaoAK \(kakaoDevApiKey)"
    ]
    
    AF.request(url, method: .get, parameters: parameters, headers: headers)
      .validate()
      .responseDecodable(of: RegionResponse.self) { response in
        switch response.result {
        case .success(let regionResponse):
          let filteredDocuments = regionResponse.documents.filter { $0.regionType == "H" }
          completion(filteredDocuments, nil)
        case .failure(let error):
          completion(nil, error)
        }
      }
  }
}
