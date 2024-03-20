//
//  FixedTrackersStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.03.2024.
//
import UIKit
import CoreData
final class FixedTrackersStore: FixedTrackersStoreProtocol {
    private let context: NSManagedObjectContext
    private let entityName = "FixedTrackersCD"

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addTracker(tracker: Tracker) {
        let managedRecord = FixedTrackersCD(context: context)
        managedRecord.trackerId = tracker.id
        saveContext()
    }

    func delete(trackerId: UUID) {
        let request = NSFetchRequest<FixedTrackersCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(FixedTrackersCD.trackerId), trackerId as CVarArg)
        guard let fixedTrackerCD = try? context.fetch(request) else { return }

        fixedTrackerCD.forEach{ context.delete($0) }
        saveContext()
    }

    func getObjects() -> [UUID]? {
        let request = NSFetchRequest<FixedTrackersCD>(entityName: entityName)
        guard let value = try? context.fetch(request) else { return nil }
        var records:[UUID] = []
        value.forEach{
            if let record = $0.trackerId {
                records.append(record)
            }
        }
        return records
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
