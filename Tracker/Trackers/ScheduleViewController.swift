//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 14.12.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {

    weak var delegate: ScheduleViewControllerDelegate?
    
    private let dayOfWeek: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    private var choseDay: [DayOfWeek] = []

    private lazy var pageNameLabel: UILabel = {
        let pageName = NSLocalizedString("scheduleView.pageName", comment: "Text displayed like page name")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = pageName
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let doneButtonName = NSLocalizedString("scheduleView.doneButtonName", comment: "Text displayed like name of Done button")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle(doneButtonName, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegateChange()
    }

    func setupTableView(choseDay: [DayOfWeek]) {
        self.choseDay = choseDay
    }


    @objc private func didTapDoneButton() {
        self.dismiss(animated: true)
    }

    private func delegateChange() {
        delegate?.fetchDayOfWeek(dayOfWeek: choseDay)
    }

    private func setupView() {

        view.backgroundColor = .ypWhite
        view.addSubview(pageNameLabel)
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            scheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 10),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

//MARK: -UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell
        if choseDay.contains(dayOfWeek[indexPath.row]) {
            guard let index = choseDay.firstIndex(of: dayOfWeek[indexPath.row]) else {return}
            choseDay.remove(at: index)
            cell?.setSwitchOff()
        } else {
            choseDay.append(dayOfWeek[indexPath.row])
            cell?.setSwitchOn()
        }
    }
}

//MARK: -UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayOfWeek.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else {
            return UITableViewCell()
        }

        cell.configCell(rowOfCell: indexPath.row, maxCount: dayOfWeek.count, dayName: dayOfWeek[indexPath.row].nameString)
        if choseDay.contains(dayOfWeek[indexPath.row]) {
            cell.setSwitchOn()
        }

        if dayOfWeek.count >= 2 {
            if indexPath.row >= 0 && indexPath.row < dayOfWeek.count - 1 {
                cell.setSeparatorView()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
