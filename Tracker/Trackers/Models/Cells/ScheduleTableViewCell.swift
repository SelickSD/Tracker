//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 14.12.2023.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
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
        button.addTarget(self, action: #selector(didTapDayOfWeekButton), for: .touchUpInside)
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

    func setSwitchOn() {
        dayOfWeekSwitch.setOn(true, animated: true)
    }

    func setSwitchOff() {
        dayOfWeekSwitch.setOn(false, animated: true)
    }

    @objc private func didTapDayOfWeekButton() {
        dayOfWeekSwitch.setOn(true, animated: true)
        print("true")
    }

    func configCell(rowOfCell: Int, maxCount: Int, dayName: String) {
        titleLabel.text = dayName

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
