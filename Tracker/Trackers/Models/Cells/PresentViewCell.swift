//
//  PresentViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 20.01.2024.
//

import UIKit

class PresentViewCell: UICollectionViewCell {
    static let identifier = "PresentViewCell"

    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 12
        self.clipsToBounds = true
//        self.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false


       NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
