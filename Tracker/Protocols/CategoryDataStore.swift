//
//  CategoryDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import CoreData

protocol CategoryDataStore {
    func addNewRecord(name: String)
    func getObjects() -> [TrackerCategoryCD]?
    func delete(_ record: NSManagedObject) throws
    func createCategory(name: String) -> NSManagedObjectID
}
