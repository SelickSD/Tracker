//
//  FixedTrackersStoreProtocol.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.03.2024.
//

import Foundation
protocol FixedTrackersStoreProtocol {
    func addTracker(tracker: Tracker)
    func delete(trackerId: UUID)
    func getObjects() -> [UUID]?
}
