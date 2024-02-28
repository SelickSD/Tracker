//
//  RecordDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//
import CoreData

protocol RecordDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ record: TrackerRecord) throws
    func delete(_ record: NSManagedObject) throws
}
