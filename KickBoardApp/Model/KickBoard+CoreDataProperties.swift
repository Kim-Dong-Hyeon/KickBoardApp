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
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var isRented: Bool

}

extension KickBoard : Identifiable {

}
