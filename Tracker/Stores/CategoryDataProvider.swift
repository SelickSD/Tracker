//
//  CategoryDataProvider.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import Foundation
import CoreData

final class CategoryDataProvider: DataProviderProtocol {
    var numberOfSections: Int

    enum DataProviderError: Error {
        case failedToInitializeContext
    }

    weak var delegate: DataProviderDelegate?

    private let context: NSManagedObjectContext
    private let dataStore: CategoryDataStore


    init(_ dataStore: CategoryDataStore, delegate: DataProviderDelegate) throws {
        guard let context = dataStore.managedObjectContext else {
            throw DataProviderError.failedToInitializeContext
        }
        self.delegate = delegate
        self.context = context
        self.dataStore = dataStore
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        <#code#>
    }

    func object(at: IndexPath) -> Tracker? {
        <#code#>
    }

    func addRecord(_ record: Tracker) throws {
        <#code#>
    }

    func deleteRecord(at indexPath: IndexPath) throws {
        <#code#>
    }
}
