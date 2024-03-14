//
//  CategoryDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//
import Foundation
protocol CategoryDataStore {
    func createCategory(name: String) -> TrackerCategoryCD
    func getObjects() -> [TrackerCategoryCD]?
    func getCategoryName(name: String) -> [TrackerCategoryCD]?
    func createNewCategory(name: String)
    func getCategoriesStringName() -> [String]?
}
