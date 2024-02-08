//
//  Date + Extensions.swift
//  Tracker
//
//  Created by Сергей Денисенко on 19.12.2023.
//

import Foundation

extension Date {
    func days(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int {
        return calendar.dateComponents([.day], from: self, to: secondDate).day!
    }
}
