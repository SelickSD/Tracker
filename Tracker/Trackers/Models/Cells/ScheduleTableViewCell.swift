//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 14.12.2023.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    static let identifier = "ScheduleTableViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()

    private lazy var dayOfWeekSwitch: UISwitch = {
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapNextButton() {

    }

    func configCell(rowOfCell: Int, maxCount: Int) {

        switch rowOfCell {
        case 0:
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            titleLabel.text = DayOfWeek.monday.rawValue
        case 1:
            titleLabel.text = DayOfWeek.tuesday.rawValue
        case 2:
            titleLabel.text = DayOfWeek.wednesday.rawValue
        case 3:
            titleLabel.text = DayOfWeek.thursday.rawValue
        case 4:
            titleLabel.text = DayOfWeek.friday.rawValue
        case 5:
            titleLabel.text = DayOfWeek.saturday.rawValue
        case 6:
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            titleLabel.text = DayOfWeek.sunday.rawValue
        default:
            break
        }
    }

    private func setupView() {
        self.backgroundColor = .systemGray6

        self.addSubview(titleLabel)
        self.addSubview(dayOfWeekSwitch)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            dayOfWeekSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dayOfWeekSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
