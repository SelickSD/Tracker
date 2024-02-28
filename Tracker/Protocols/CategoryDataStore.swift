//
//  CategoryDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import CoreData

protocol CategoryDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ record: TrackerCategory) throws
    func delete(_ record: NSManagedObject) throws
}
