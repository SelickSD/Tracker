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
    private let entityName = "TrackerCategoryCD"

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createCategory(name: String) -> TrackerCategoryCD {
        let managedRecord = TrackerCategoryCD(context: context)
        managedRecord.name = name
        return managedRecord
    }

    func createNewCategory(name: String) {
        let managedRecord = TrackerCategoryCD(context: context)
        managedRecord.name = name
        saveContext()
    }

    func getObjects() -> [TrackerCategoryCD]? {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: entityName)
        guard let value = try? context.fetch(request) else { return nil }
        return value
    }

    func getCategoryName(name: String) -> [TrackerCategoryCD]? {
        let request = NSFetchRequest<TrackerCategoryCD>(entityName: entityName)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCD.name), name)
        guard let category = try? context.fetch(request) else {return nil}
        return category
    }

    func getCategoriesStringName() -> [String]? {
        var categories: [String] = []
        let objects = getObjects()

        objects?.forEach{
            if let name = $0.name {
                categories.append(name)
            }
        }
        return categories
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
