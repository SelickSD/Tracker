//
//  Date + Extensions.swift
//  Tracker
//
//  Created by Сергей Денисенко on 19.12.2023.
//

import Foundation

extension Date {

    var ignoringTime: Date? {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return Calendar.current.date(from: dateComponents)
    }

    func days(to secondDate: Date, calendar: Calendar = Calendar.current) -> Int {
        return calendar.dateComponents([.day], from: self, to: secondDate).day!
    }
}
