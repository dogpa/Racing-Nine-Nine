//
//  TimeRecord+CoreDataProperties.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/30.
//
//

import Foundation
import CoreData


extension TimeRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeRecord> {
        return NSFetchRequest<TimeRecord>(entityName: "TimeRecord")
    }

    @NSManaged public var recordDate: Date?
    @NSManaged public var recordTime: Int32
    @NSManaged public var recordType: String?

}

extension TimeRecord : Identifiable {

}
