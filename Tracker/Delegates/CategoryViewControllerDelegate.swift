//
//  CategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 23.01.2024.
//
import Foundation
protocol CategoryViewControllerDelegate: AnyObject {
    func fetchCategory(index: Int?, categories: [String])
}
