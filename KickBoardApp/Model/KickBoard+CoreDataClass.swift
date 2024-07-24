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
    static let isRented = "isRented"
    static let currentLatitude = "currentLatitude"
    static let currentLongitude = "currentLongitude"
    static let expirationDate = "expirationDate"
    static let imageData = "imageData"
    static let modelName = "modelName"
    static let registedDate = "registedDate"
    static let registedLocation = "registedLocation"
    static let registrant = "registrant"
  }
}
