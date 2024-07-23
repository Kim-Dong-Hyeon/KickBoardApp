//
//  User+CoreDataProperties.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/22/24.
//
//

import Foundation
import CoreData


extension User {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
    return NSFetchRequest<User>(entityName: "User")
  }
  
  @NSManaged public var id: String?
  @NSManaged public var state: Bool
  @NSManaged public var password: String?
  @NSManaged public var phoneNumber: String?
  @NSManaged public var memberType: String?
  @NSManaged public var name: String?
}

extension User : Identifiable {
  
}
