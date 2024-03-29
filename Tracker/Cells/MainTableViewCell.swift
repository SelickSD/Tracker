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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(named: "Chevron"), for: .normal)
        button.tintColor = .ypBlack
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        self.selectionStyle = .none

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configLabel(newLabelText: String) {
        categoryLabel.text = newLabelText
        updateView()
        layoutIfNeeded()
    }

    func discardChanges() {
        [titleLabel, nextButton, categoryLabel].forEach{
            $0.removeFromSuperview()
        }
        setupView()
        layoutIfNeeded()
    }

    func configCell(rowOfCell: Int, maxCount: Int) {
        let categoryCellName = NSLocalizedString("mainTableViewCell.categoryCellName", 
                                                 comment: "Text displayed like cell name")
        let scheduleCellName = NSLocalizedString("mainTableViewCell.scheduleCellName", 
                                                 comment: "Text displayed like cell name")

        if maxCount == 1 {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            titleLabel.text = categoryCellName
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            switch rowOfCell {
            case 0:
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                titleLabel.text = categoryCellName
            case maxCount - 1:
                self.layer.masksToBounds = true
                self.layer.cornerRadius = 10
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                titleLabel.text = scheduleCellName
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
