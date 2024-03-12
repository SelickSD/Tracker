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

    private let fixedRecordDataStore: FixedTrackersStoreProtocol? = {
        return FixedTrackersStore()
    }()

    init() {}

    func addNewCategory(category: TrackerCategory) {
        guard let categories = categoryDataStore?.getCategoryName(name: category.name)?.first else {
            guard let categoryObject = categoryDataStore?.createCategory(name: category.name) else { return }
            trackerDataStore?.createNewTracker(tracker: category.trackers[0], category: categoryObject)
            return
        }
        trackerDataStore?.createNewTracker(tracker: category.trackers[0], category: categories)
    }

    func getObjects() -> ([TrackerCategory]?, [TrackerRecord]?, [Tracker]?) {
        guard let categories = categoryDataStore?.getObjects(),
              let records = recordDataStore?.getObjects(),
              let trackerID = fixedRecordDataStore?.getObjects() as? [UUID] else { return (nil, nil, nil) }
        var newCategories:[TrackerCategory] = []
        var newTrackers:[Tracker] = []

        categories.forEach{
            if let name = $0.name {
                newCategories.append(TrackerCategory(name: name,
                                                     trackers: trackerDataStore?.getCategoryObjects(category: $0) ?? []))
            }
        }

        trackerID.forEach{
            if let tracker = trackerDataStore?.getTracker(trackerId: $0) {
                newTrackers.append(tracker)
            }
        }
        return (newCategories, records, newTrackers)
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

    func fixTracker(tracker: Tracker) {
        fixedRecordDataStore?.addTracker(tracker: tracker)
    }

    func unFixTracker(tracker: Tracker) {
        fixedRecordDataStore?.delete(trackerId: tracker.id)
    }

    func deleteTracker(tracker: Tracker) {
        fixedRecordDataStore?.delete(trackerId: tracker.id)
        recordDataStore?.deleteID(trackerId: tracker.id)
        trackerDataStore?.deleteID(trackerId: tracker.id)
    }
}
