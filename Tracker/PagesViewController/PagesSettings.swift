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
            return "Отслеживайте только то, что хотите"
        case .red:
            return "Даже если это не литры воды и йога"
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
