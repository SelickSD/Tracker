//
//  DataProviderProtocol.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import Foundation

protocol DataProviderProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at: IndexPath) -> Tracker?
    func addRecord(_ record: Tracker) throws
    func deleteRecord(at indexPath: IndexPath) throws
}
