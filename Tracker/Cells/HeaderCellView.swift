//
//  HeaderCellView.swift
//  Tracker
//
//  Created by Сергей Денисенко on 10.12.2023.
//
import UIKit
final class HeaderCellView: UICollectionReusableView {
    static let identifier = "TrackersCellHeader"
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepareView(name: String) {
        titleLabel.text = name
        setupView()
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
