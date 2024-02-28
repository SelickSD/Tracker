//
//  DataProviderDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 28.02.2024.
//

import Foundation

protocol DataProviderDelegate: AnyObject {
    func didUpdate(_ update: TrackerStoreUpdate)
}
