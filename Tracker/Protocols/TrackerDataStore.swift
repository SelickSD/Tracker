//
//  TrackerDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//
import Foundation
protocol TrackerDataStore {
    func getCategoryObjects(category: TrackerCategoryCD) -> [Tracker]?
    func createNewTracker(tracker: Tracker, category: TrackerCategoryCD)
    func getTracker(trackerId: UUID) -> Tracker?
    func deleteID(trackerId: UUID)
}
