//
//  TrackersViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 24.01.2024.
//

import Foundation
protocol TrackersViewControllerDelegate: AnyObject {
    func fetchNewTrack(newHabit: TrackerCategory)
}
