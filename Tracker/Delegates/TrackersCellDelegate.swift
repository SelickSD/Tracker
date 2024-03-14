//
//  TrackersCellDelegate.swift
//  Tracker
//
//  Created by Сергей Денисенко on 19.12.2023.
//
import Foundation
protocol TrackersCellDelegate: AnyObject {
    func didTapPlusButton(id: UUID)
    func didUnTapPlusButton(id: UUID)
}
