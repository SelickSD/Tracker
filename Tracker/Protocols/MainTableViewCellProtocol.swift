//
//  MainTableViewCellProtocol.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//

import Foundation

protocol MainTableViewCellProtocol {
    func configLabel(newLabelText: String)
    func discardChanges()
    func configCell(rowOfCell: Int, maxCount: Int)
}
