//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 27.02.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: RecordDataStore {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init() {
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        context = container.viewContext
    }

    func add(_ record: TrackerRecord) throws {
        <#code#>
    }

    func delete(_ record: NSManagedObject) throws {
        <#code#>
    }
}
