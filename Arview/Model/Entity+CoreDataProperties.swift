//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Zakirov Tahir on 25.04.2021.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var channels: Int64
    @NSManaged public var viewers: Int64
    @NSManaged public var medium: Data?

}
