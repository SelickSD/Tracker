//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.12.2023.
//

import Foundation

struct TrackerCategory {
    let name: String
    var trackers: [Tracker]

    mutating func updateTrackers(tracker: Tracker) {
        self.trackers.append(tracker)
    }
}
