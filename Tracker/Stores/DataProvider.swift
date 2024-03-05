//
//  DataProvider.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import UIKit

final class DataProvider: DataProviderProtocol {

    enum DataProviderError: Error {
        case failedToInitializeContext
    }

    private let categoryDataStore: CategoryDataStore
    private let trackerDataStore: TrackerDataStore
    private let recordDataStore: RecordDataStore

    init() {
        self.trackerDataStore = TrackerStore()
        self.categoryDataStore = TrackerCategoryStore()
        self.recordDataStore = TrackerRecordStore()
    }

    func addNewCategory(category: TrackerCategory) {
        let categoryObjectID = categoryDataStore.createCategory(name: category.name)
        trackerDataStore.createNewTracker(tracker: category.trackers[0], categoryID: categoryObjectID)
    }

    func getObjects() -> ([TrackerCategory]?, [TrackerRecord]?) {
        guard let categories = categoryDataStore.getObjects(),
              let records = recordDataStore.getObjects() else { return (nil, nil) }
        var newCategories:[TrackerCategory] = []

        categories.forEach{
            if let name = $0.name {
                newCategories.append(TrackerCategory(name: name, 
                                                     trackers: trackerDataStore.getCategoryObjects(category: $0) ?? []))
            }
        }
        return (newCategories, records)
    }

    func addNewTracker(tracker: Tracker, toCategoryName: String) {
        guard let category = categoryDataStore.getCategoryName(name: toCategoryName)?.first else {return}
        trackerDataStore.createNewTracker(tracker: tracker, category: category)
    }

    func addRecord(record: TrackerRecord) {
        recordDataStore.add(record: record)
    }

    func deleteRecord(record: TrackerRecord) {
        recordDataStore.delete(record: record)
    }
}
