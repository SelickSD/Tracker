//
//  DataProvider.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import UIKit
import CoreData

final class DataProvider: DataProviderProtocol {

    enum DataProviderError: Error {
        case failedToInitializeContext
    }

    weak var delegate: DataProviderDelegate?

    private let context: NSManagedObjectContext
    private let categoryDataStore: TrackerCategoryStore
    private let trackerDataStore: TrackerDataStore
    private let recordDataStore: TrackerRecordStore

    private let categoryEntityName = "TrackerCategoryCD"
    private let trackerEntityName = "TrackerCD"
    private let recordEntityName = "TrackerRecordCD"


    init(delegate: DataProviderDelegate) throws {

        let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

        self.delegate = delegate
        self.context = container.viewContext
        self.trackerDataStore = TrackerStore(context: context)
        self.categoryDataStore = TrackerCategoryStore(context: context)
        self.recordDataStore = TrackerRecordStore()
    }


    func addNewCategory(category: TrackerCategory) {
        let categoryObjectID = categoryDataStore.createCategory(name: category.name)
        let trackerObjectID = trackerDataStore.createNewTracker(tracker: category.trackers[0])
        guard let newCategory = try? context.existingObject(with: categoryObjectID) as? TrackerCategoryCD,
        let newTracker = try? context.existingObject(with: trackerObjectID) as? TrackerCD else {return}

        newCategory.addToTrackers(newTracker)

        saveContext()
    }

    func object(at: IndexPath) -> Tracker? {
//        let request = NSFetchRequest<TrackerCD>(entityName: "TrackerCD")
//        guard let value = try? context.fetch(request) else { return nil }
//        guard let object = convertCD(cd: value[at.row]) else { return nil }
//
//        return object
    }

    func getObjects() -> [TrackerCategory]? {
        guard let categories = categoryDataStore.getObjects() else {return nil}
        var trackerCategories: [TrackerCategory] = []

        for items in categories {

            if let name = items.name {
                trackerCategories.append(TrackerCategory(name: name, trackers: <#T##[Tracker]#>))
            }

        }





//        let request = NSFetchRequest<TrackerCD>(entityName: "TrackerCD")
//        guard let value = try? context.fetch(request) else { return nil }
//
//        var object: [Tracker] = []
//        for item in value {
//            if let tempCD = convertCD(cd: item) {
//                object.append(tempCD)
//            }
//        }

        return nil
    }

    func addRecord(_ record: Tracker) throws {
        try? trackerDataStore.add(record)
    }

    func deleteRecord(at indexPath: IndexPath) throws {
        let request = NSFetchRequest<TrackerCD>(entityName: "TrackerCD")
        guard let value = try? context.fetch(request) else { return }
        value.forEach{
            context.delete($0)
        }
        try? context.save()

    }

    private func convertCD(cd: [TrackerCD]) -> [Tracker]? {
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

    private func saveContext() {
         if context.hasChanges {
             do {
                 try context.save()
                 try print(context.count(for: NSFetchRequest<TrackerCD>(entityName: "TrackerCD")))
             } catch {
                 let nserror = error as NSError
                 context.rollback()
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         }
     }

}
