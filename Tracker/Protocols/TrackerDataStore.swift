//
//  TrackerDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import CoreData

protocol TrackerDataStore {
    func add(_ record: Tracker) throws
    func delete(_ record: NSManagedObject) throws
    func createNewTracker(tracker: Tracker) -> NSManagedObjectID
}
