//
//  Color.swift
//  Tracker
//
//  Created by Сергей Денисенко on 13.03.2024.
//

import UIKit

final class Colors {
    let viewBackgroundColor = UIColor.systemBackground

    let buttonDisabledColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor(hex: "#3772E7") ?? .ypBlue
        } else {
            return UIColor(hex: "#3772E7") ?? .ypBlue
        }
    }
}
