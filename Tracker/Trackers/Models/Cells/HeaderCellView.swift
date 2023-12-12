//
//  HeaderCellView.swift
//  Tracker
//
//  Created by Сергей Денисенко on 10.12.2023.
//

import UIKit

class HeaderCellView: UICollectionReusableView {
    static let identifier = "TrackersCellHeader"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Домашний уют"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {

        self.clipsToBounds = true
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
