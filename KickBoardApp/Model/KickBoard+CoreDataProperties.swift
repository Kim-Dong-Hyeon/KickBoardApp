//
//  KickBoard+CoreDataProperties.swift
//  KickBoardApp
//
//  Created by 김동현 on 7/23/24.
//
//

import Foundation
import CoreData


extension KickBoard {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<KickBoard> {
    return NSFetchRequest<KickBoard>(entityName: "KickBoard")
  }
  
  @NSManaged public var id: String?
  @NSManaged public var isRented: Bool
  @NSManaged public var currentLatitude: Double
  @NSManaged public var currentLongitude: Double
  @NSManaged public var expirationDate: String?
  @NSManaged public var imageData: Data?
  @NSManaged public var modelName: String?
  @NSManaged public var registedDate: String?
  @NSManaged public var registedLocation: String?
  @NSManaged public var registrant: String?
  
}

extension KickBoard : Identifiable {
  
}
