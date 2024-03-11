//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import Foundation
protocol DataProviderProtocol {
    func addNewCategory(category: TrackerCategory)
    func getObjects() -> ([TrackerCategory]?, [TrackerRecord]?, [Tracker]?)
    func addNewTracker(tracker: Tracker, toCategoryName: String)
    func addRecord(record: TrackerRecord)
    func deleteRecord(record: TrackerRecord)
    func fixTracker(tracker: Tracker)
    func unFixTracker(tracker: Tracker)
}
