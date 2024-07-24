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
    static let name = "name"
    static let price = "price"
    static let statDate = "statDate"
    static let endDate = "endDate"
    static let time = "time"
    static let userId = "userId"
  }
}
