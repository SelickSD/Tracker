//
//  TrackerDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import CoreData

protocol TrackerDataStore {
    func createNewTracker(tracker: Tracker, categoryID: NSManagedObjectID)
    func getCategoryObjects(category: TrackerCategoryCD) -> [Tracker]?
    func createNewTracker(tracker: Tracker, category: TrackerCategoryCD)
}
