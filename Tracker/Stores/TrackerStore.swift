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
    private let entityName = "TrackerCD"

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createNewTracker(tracker: Tracker, category: TrackerCategoryCD) {
        let managedRecord = TrackerCD(context: context)
        managedRecord.trackerId = tracker.id
        managedRecord.name = tracker.name
        managedRecord.color = tracker.color
        managedRecord.emoji = tracker.emoji
        managedRecord.schedule = tracker.schedule as NSObject
        managedRecord.category = category

        saveContext()
    }

    func getCategoryObjects(category: TrackerCategoryCD) -> [Tracker]? {
        let request = NSFetchRequest<TrackerCD>(entityName: entityName)
        guard let value = try? context.fetch(request) else { return nil }
        var trackers: [Tracker] = []

        value.forEach{
            if $0.category == category {
                if let tracker = convertCD(cd: $0) {
                    trackers.append(tracker)
                }
            }
        }
        return trackers
    }

    func getTracker(trackerId: UUID) -> Tracker? {
        let request = NSFetchRequest<TrackerCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCD.trackerId), trackerId as CVarArg)
        guard let tracker = try? context.fetch(request) else { return nil }
        return convertCD(cd: tracker.first)
    }

    func deleteID(trackerId: UUID) {
        let request = NSFetchRequest<TrackerCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCD.trackerId), trackerId as CVarArg)
        guard let trackerCD = try? context.fetch(request) else { return }

        trackerCD.forEach{ context.delete($0) }
        saveContext()
    }

    private func convertCD(cd: TrackerCD?) -> Tracker? {
        guard let tracker = cd,
              let id = tracker.trackerId,
              let color = tracker.color as? UIColor,
              let name = tracker.name,
              let emoji = tracker.emoji,
              let schedule = tracker.schedule as? [DayOfWeek]
        else {return nil}

        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       schedule: schedule)
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
