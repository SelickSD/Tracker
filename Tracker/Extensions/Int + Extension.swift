//
//  Int + Extension.swift
//  Tracker
//
//  Created by Сергей Денисенко on 25.01.2024.
//

import Foundation

extension Int {
    func days() -> String {
        let tasksString = String.localizedStringWithFormat(
            NSLocalizedString("numberOfTasks", comment: "Number of remaining tasks"),
            self
        )
        return tasksString
    }
}
