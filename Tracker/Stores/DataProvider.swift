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

    private lazy var categoryDataStore: CategoryDataStore? = {
        return TrackerCategoryStore()
    }()

    private lazy var trackerDataStore: TrackerDataStore? = {
        return TrackerStore()
    }()
    private let recordDataStore: RecordDataStore? = {
        return TrackerRecordStore()
    }()

    init() {}

    func addNewCategory(category: TrackerCategory) {
        guard let categoryObjectID = categoryDataStore?.createCategory(name: category.name) else { return }
        trackerDataStore?.createNewTracker(tracker: category.trackers[0], categoryID: categoryObjectID)
    }

    func getObjects() -> ([TrackerCategory]?, [TrackerRecord]?) {
        guard let categories = categoryDataStore?.getObjects(),
              let records = recordDataStore?.getObjects() else { return (nil, nil) }
        var newCategories:[TrackerCategory] = []

        categories.forEach{
            if let name = $0.name {
                newCategories.append(TrackerCategory(name: name, 
                                                     trackers: trackerDataStore?.getCategoryObjects(category: $0) ?? []))
            }
        }
        return (newCategories, records)
    }

    func addNewTracker(tracker: Tracker, toCategoryName: String) {
        guard let category = categoryDataStore?.getCategoryName(name: toCategoryName)?.first else {return}
        trackerDataStore?.createNewTracker(tracker: tracker, category: category)
    }

    func addRecord(record: TrackerRecord) {
        recordDataStore?.add(record: record)
    }

    func deleteRecord(record: TrackerRecord) {
        recordDataStore?.delete(record: record)
    }
}
