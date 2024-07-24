//
//  User+CoreDataProperties.swift
//  KickBoardApp
//
//  Created by 전성진 on 7/24/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var gender: String?
    @NSManaged public var id: String?
    @NSManaged public var memberType: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var state: Bool
    @NSManaged public var rideId: NSSet?
    @NSManaged public var kickBoardId: NSSet?

}

// MARK: Generated accessors for rideId
extension User {

    @objc(addRideIdObject:)
    @NSManaged public func addToRideId(_ value: Ride)

    @objc(removeRideIdObject:)
    @NSManaged public func removeFromRideId(_ value: Ride)

    @objc(addRideId:)
    @NSManaged public func addToRideId(_ values: NSSet)

    @objc(removeRideId:)
    @NSManaged public func removeFromRideId(_ values: NSSet)

}

// MARK: Generated accessors for kickBoardId
extension User {

    @objc(addKickBoardIdObject:)
    @NSManaged public func addToKickBoardId(_ value: KickBoard)

    @objc(removeKickBoardIdObject:)
    @NSManaged public func removeFromKickBoardId(_ value: KickBoard)

    @objc(addKickBoardId:)
    @NSManaged public func addToKickBoardId(_ values: NSSet)

    @objc(removeKickBoardId:)
    @NSManaged public func removeFromKickBoardId(_ values: NSSet)

}

extension User : Identifiable {

}
