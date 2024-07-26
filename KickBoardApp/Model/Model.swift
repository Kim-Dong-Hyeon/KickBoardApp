//
//  Model.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/22/24.
//

import Foundation

import CoreLocation

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
        
        let center = CLLocationCoordinate2D(latitude: 37.533, longitude: 126.996)
        
        let styleIds = [
            "orange",
            "red",
            "green",
            "blue"
        ]
        
        for index in 0 ... 100 {
            let position = CLLocationCoordinate2D(latitude: center.latitude + drand48(),
                                                  longitude: center.longitude + drand48())
            let data = PoiData(id: "poi" + String(index),
                               position: position,
                               styleID: "label_default_style",
                               name: "place" + String(index))
            
            datas.append(data)
        }
        
        return datas
    }

    static var datas = [PoiData]()
}
