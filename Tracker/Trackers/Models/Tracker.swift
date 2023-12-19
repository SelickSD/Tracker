//
//  Tracker.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.12.2023.
//

import UIKit

struct Tracker {
    let id: UUID = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]
}
