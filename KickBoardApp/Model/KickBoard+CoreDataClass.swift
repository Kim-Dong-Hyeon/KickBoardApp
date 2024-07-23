//
//  KickBoard+CoreDataClass.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/23/24.
//
//

import Foundation
import CoreData

@objc(KickBoard)
public class KickBoard: NSManagedObject {
  public static let className = "KickBoard"
  public enum Key {
    static let id = "id"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let isRented = "isRented"
  }

}
