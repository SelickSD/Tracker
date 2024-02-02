//
//  CategoriesTableViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 23.01.2024.
//

import UIKit

final class CategoriesTableViewCell: UITableViewCell {
    static let identifier = "CategoriesTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Done"), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.clipsToBounds = true
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapNextButton() {
        //TODO
    }

    func configCell(rowOfCell: Int, maxCount: Int, category: String) {
        titleLabel.text = category

        if maxCount == 1 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            switch rowOfCell {
            case 0:
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            case maxCount - 1:
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            default:
                break
            }
        }
    }

    func makeDone() {
        doneButton.isHidden.toggle()
    }

    private func setupView() {
        self.backgroundColor = .systemGray6
        self.addSubview(titleLabel)
        self.addSubview(doneButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            doneButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}

