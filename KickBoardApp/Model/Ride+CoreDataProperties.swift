//
//  Ride+CoreDataProperties.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/24/24.
//
//

import Foundation
import CoreData


extension Ride {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ride> {
        return NSFetchRequest<Ride>(entityName: "Ride")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var startDate: Date?
    @NSManaged public var time: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var userId: User?

}

// MARK: Generated accessors for userId
extension Ride {

    @objc(addUserIdObject:)
    @NSManaged public func addToUserId(_ value: User)

    @objc(removeUserIdObject:)
    @NSManaged public func removeFromUserId(_ value: User)

    @objc(addUserId:)
    @NSManaged public func addToUserId(_ values: NSSet)

    @objc(removeUserId:)
    @NSManaged public func removeFromUserId(_ values: NSSet)

}

extension Ride : Identifiable {

}
