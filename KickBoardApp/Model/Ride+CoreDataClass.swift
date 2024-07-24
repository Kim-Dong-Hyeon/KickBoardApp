//
//  Ride+CoreDataClass.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/24/24.
//
//

import Foundation
import CoreData

@objc(Ride)
public class Ride: NSManagedObject {
  public static let className = "Ride"
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
