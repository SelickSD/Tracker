//
//  TrackerStore.swift
//  Tracker
//
//  Created by Сергей Денисенко on 27.02.2024.
//

import UIKit
import CoreData

final class TrackerStore: TrackerDataStore {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    init() {
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        context = container.viewContext
    }

    func add(_ record: Tracker) throws {
        <#code#>
    }

    func delete(_ record: NSManagedObject) throws {
        <#code#>
    }
}
