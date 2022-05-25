//
//  RecordProperty.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 25.05.22.
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var avg: Int16
    @NSManaged public var date: Date?
    @NSManaged public var length: String?
    @NSManaged public var max: Int16
    @NSManaged public var min: Int16
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?

}
