//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 27.02.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: CategoryDataStore {

    private let context: NSManagedObjectContext
    private let categoryEntityName = "TrackerCategoryCD"

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createCategory(name: String) -> NSManagedObjectID {
        let managedRecord = TrackerCategoryCD(context: context)
        managedRecord.name = name
        return managedRecord.objectID
    }

    func getObjects() -> [TrackerCategoryCD]? {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: categoryEntityName)
        guard let value = try? context.fetch(request) else { return nil }
        return value
    }

    func addNewRecord(name: String) {
        let managedRecord = TrackerCategoryCD(context: context)
        managedRecord.name = name
    }

    func delete(_ record: NSManagedObject) throws {
        context.delete(record)
        try? context.save()
    }
}
