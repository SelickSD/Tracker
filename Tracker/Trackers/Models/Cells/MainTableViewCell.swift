//
//  MainTableViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 12.12.2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor = .lightGray
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapNextButton() {
        // TODO
    }

    func configLabel(newLabelText: String) {
        categoryLabel.text = newLabelText
        updateView()
        layoutIfNeeded()
    }

    func discardChanges() {
        titleLabel.removeFromSuperview()
        nextButton.removeFromSuperview()
        categoryLabel.removeFromSuperview()

        setupView()
        layoutIfNeeded()

    }

    func configCell(rowOfCell: Int, maxCount: Int) {
        if maxCount == 1 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            titleLabel.text = "Категория"
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            switch rowOfCell {
            case 0:
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                titleLabel.text = "Категория"
            case maxCount - 1:
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                titleLabel.text = "Расписание"
            default:
                break
            }
        }
    }

    private func setupView() {
        self.backgroundColor = .systemGray6
        self.addSubview(titleLabel)
        self.addSubview(nextButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }

    private func updateView() {
        titleLabel.removeFromSuperview()
        nextButton.removeFromSuperview()
        self.addSubview(titleLabel)
        self.addSubview(categoryLabel)
        self.addSubview(nextButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),

            categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),

            nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
