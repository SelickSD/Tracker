//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 24.01.2024.
//
import Foundation
protocol ScheduleViewControllerDelegate: AnyObject {
    func fetchDayOfWeek(dayOfWeek: [DayOfWeek])
}
