//
//  RecordDataStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//
import CoreData

protocol RecordDataStore {
    func add(record: TrackerRecord)
    func delete(record: TrackerRecord)
    func getObjects() -> [TrackerRecord]?
}
