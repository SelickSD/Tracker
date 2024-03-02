//
//  TrackerStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 27.02.2024.
//

import UIKit
import CoreData

final class TrackerStore: TrackerDataStore {

    private let context: NSManagedObjectContext
    private let trackerEntityName = "TrackerCD"

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createNewTracker(tracker: Tracker) -> NSManagedObjectID {
        let managedRecord = TrackerCD(context: context)
        managedRecord.id = tracker.id
        managedRecord.name = tracker.name
        managedRecord.color = tracker.color
        managedRecord.emoji = tracker.emoji
        managedRecord.schedule = tracker.schedule as NSObject
        return managedRecord.objectID
    }

    

    private func convertCD(cd: TrackerCD) -> Tracker? {
        guard let color = cd.color as? UIColor,
              let name = cd.name,
              let emoji = cd.emoji,
              let schedule = cd.schedule as? [DayOfWeek]
        else {return nil}

        return Tracker(name: name,
                       color: color,
                       emoji: emoji,
                       schedule: schedule)
    }


    func add(category: NSManagedObject, record: Tracker) {
        let managedRecord = TrackerCD(context: context)
        managedRecord.id = record.id
        managedRecord.name = record.name
        managedRecord.color = record.color
        managedRecord.emoji = record.emoji
        managedRecord.schedule = record.schedule as NSObject
    }

    func delete(_ record: NSManagedObject) throws {
        let value = TrackerCD(context: context)
    }



    func add(_ record: Tracker) throws {

    }
}
