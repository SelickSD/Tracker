//
//  FilterViewDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 13.03.2024.
//
import Foundation
protocol FilterViewDelegate: AnyObject {
    func fetchFilter(chooseFilter: Filters)
}
