//
//  Model.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import CoreData
import CoreLocation
import UIKit

struct PoiData {
  var id: String
  var position: CLLocationCoordinate2D
  var styleID: String
  var name: String
}

// dummy data 생성
class PoiDataSample {
  static func createPoiData() -> [PoiData] {
    if datas.isEmpty == false {
      return datas
    }
    
    var list: [KickBoard] = []
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    do {
      let request = KickBoard.fetchRequest()
      // 속성으로 데이터 정렬해서 가져오기
      let KickBoards = try container.viewContext.fetch(request)
      list = KickBoards
      
      print("리스트 불러오기 성공")
      print(list)
    } catch {
      print("리스트 불러오기 실패")
    }
    
    let center = CLLocationCoordinate2D(latitude: 37.533, longitude: 126.996)
    
    let styleIds = [
      "orange",
      "red",
      "green",
      "blue"
    ]
    
    for kickBoard in list {
//      let position = CLLocationCoordinate2D(latitude: center.latitude + drand48(),
//                                            longitude: center.longitude + drand48())
      let position = CLLocationCoordinate2D(latitude: 37.553,
                                            longitude: 126.996)
      let data = PoiData(id: kickBoard.id ?? "",
                         position: position,
                         styleID: "label_default_style",
                         name: kickBoard.modelName ?? "")
      
      datas.append(data)
    }
    
    return datas
  }
  
  static var datas = [PoiData]()
}
