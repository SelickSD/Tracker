//
//  PagesSettings.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//
import UIKit
enum PagesSettings {
    case blue
    case red

    var label: String {
        switch self {
        case .blue:
            return NSLocalizedString("pagesSettings.fistPage",
                                     comment: "Text displayed like page description")
        case .red:
            return NSLocalizedString("pagesSettings.secondPage",
                                     comment: "Text displayed like page description")
        }
    }

    var image: UIImage? {
        switch self {
        case .blue:
            return UIImage(named: "OnbordBlue")
        case .red:
            return UIImage(named: "OnbordRed")
        }
    }
}
