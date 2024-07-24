//
//  User+CoreDataClass.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/24/24.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
  public static let className = "User"
  public enum Key {
    static let id = "id"
    static let state = "state"
    static let password = "password"
    static let phoneNumber = "phoneNumber"
    static let memberType = "memberType"
    static let name = "name"
    static let gender = "gender"
  }
}
