//
//  CategoryDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import CoreData

protocol CategoryDataStore {
    func createCategory(name: String) -> NSManagedObjectID
    func getObjects() -> [TrackerCategoryCD]?
    func getCategoryName(name: String) -> [TrackerCategoryCD]?
}
