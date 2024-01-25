//
//  CreateNewHabitViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 24.01.2024.
//

import Foundation
protocol CreateNewHabitViewControllerDelegate: AnyObject {
    func fetchHabit(newHabit: TrackerCategory)
}