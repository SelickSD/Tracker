//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 27.02.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: RecordDataStore {

    private let context: NSManagedObjectContext
    private let entityName = "TrackerRecordCD"

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func add(record: TrackerRecord) {
        let managedRecord = TrackerRecordCD(context: context)
        managedRecord.date = record.date
        managedRecord.trackerId =  record.id
        saveContext()
    }

    func delete(record: TrackerRecord) {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCD.trackerId), record.id as CVarArg)
        guard let recordCD = try? context.fetch(request) else { return }

        recordCD.forEach{
            if let date = $0.date {
                if date == record.date {
                    context.delete($0)
                }
            }
        }
        saveContext()
    }

    func getObjects() -> [TrackerRecord]? {
        let request = NSFetchRequest<TrackerRecordCD>(entityName: entityName)
        guard let value = try? context.fetch(request) else { return nil }
        var records:[TrackerRecord] = []
        value.forEach{
            if let record = convertCD(cd: $0) {
                records.append(record)
            }
        }
        return records
    }

    private func convertCD(cd: TrackerRecordCD?) -> TrackerRecord? {
        guard let record = cd,
              let date = record.date,
              let id = record.trackerId
        else {return nil}

        return TrackerRecord(id: id, date: date)
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
