//
//  Indicators.swift
//  Tracker
//
//  Created by Сергей Денисенко on 13.03.2024.
//

import Foundation
enum Indicators {
    case bestPeriod
    case idealDays
    case completedTrackers
    case averageValue

    var nameString: String {
        switch self {
        case .bestPeriod:
            return NSLocalizedString("indicators.bestPeriod", comment: "Text displayed track name")
        case .idealDays:
            return NSLocalizedString("indicators.idealDays", comment: "Text displayed track name")
        case .completedTrackers:
            return NSLocalizedString("indicators.completedTrackers", comment: "Text displayed track name")
        case .averageValue:
            return NSLocalizedString("indicators.averageValue", comment: "Text displayed track name")
        }
    }
}
