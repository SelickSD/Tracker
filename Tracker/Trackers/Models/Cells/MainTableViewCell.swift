//
//  MainTableViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 12.12.2023.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Домашний уют"
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupView() {
        self.backgroundColor = .systemGray6

        self.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
