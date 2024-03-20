//
//  Filters.swift
//  Tracker
//
//  Created by Сергей Денисенко on 12.03.2024.
//

import Foundation
enum Filters {
    case allTrackers
    case thisDay
    case completedTrackers
    case openTrackers

    var nameString: String {
        switch self {
        case .allTrackers:
            return NSLocalizedString("filters.allTrackers", comment: "Text displayed track name")
        case .thisDay:
            return NSLocalizedString("filters.thisDay", comment: "Text displayed track name")
        case .completedTrackers:
            return NSLocalizedString("filters.completed", comment: "Text displayed track name")
        case .openTrackers:
            return NSLocalizedString("filters.openTrackers", comment: "Text displayed track name")
        }
    }
}
