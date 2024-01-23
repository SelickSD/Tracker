//
//  CategoryViewControllerProtocol.swift
//  Tracker
//
//  Created by Сергей Денисенко on 23.01.2024.
//

import UIKit

public protocol CategoryViewControllerProtocol: AnyObject {
    func setupView(category: [String], targetCell: UITableViewCell, index: Int?)
}
