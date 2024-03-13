//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 30.11.2023.
//

import UIKit
final class StatisticViewController: UIViewController {

    private let indicators: [Indicators] = [.bestPeriod, .idealDays, .completedTrackers, .averageValue]

    private lazy var dataProvider: DataProviderProtocol? = {
        return DataProvider()
    }()

    private lazy var openingLabel: UILabel = {
        let openingLabelText = NSLocalizedString("statisticView.opening", comment: "Text displayed like page description")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = openingLabelText
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "Sad")
        return view
    }()

    private lazy var statisticTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configView()
        statisticTableView.reloadData()
    }

    private func configView() {
        guard let objects = dataProvider?.getObjects().1 else {
            setupBlankView()
            return
        }

        if objects.isEmpty {
            setupBlankView()
        } else {
            setupView()
        }
    }

    private func getCount(indicator: Indicators) -> Int {

        var count = 0
        switch indicator {
        case .averageValue:
            guard let objects = dataProvider?.getObjects().1 else {return count}
            count = averageValue(trackers: objects)
        case .bestPeriod:
            guard let objects = dataProvider?.getObjects().1 else {return count}
            count = bestPeriod(trackers: objects)
        case .completedTrackers:
            guard let objects = dataProvider?.getObjects().1 else {return count}
            count = objects.count
        case .idealDays:
            guard let objects = dataProvider?.getObjects(),
                  let record = objects.1,
                  let category = objects.0 else {return count}
            count = idealDays(trackers: record, category: category)
        }
        return count
    }

    private func averageValue(trackers: [TrackerRecord]) -> Int {
        let count = trackers.count
        var period: [Date] = []

        for value in trackers {
            if let date = value.date.ignoringTime  {
                if !period.contains(date) {
                    period.append(date)
                }
            }
        }
        if count != 0 && !period.isEmpty {
            return count / period.count
        }
        return 0
    }

    private func bestPeriod(trackers: [TrackerRecord]) -> Int {
        var count = 0
        var newCount = 1
        var period: [Date] = []

        for value in trackers {
            if let date = value.date.ignoringTime  {
                if !period.contains(date) {
                    period.append(date)
                }
            }
        }

        let newPeriod = period.sorted()

        if period.isEmpty {
            return 0
        }

        if period.count == 1 {
            return 1
        }

        for i in 0...newPeriod.count - 2 {

            if let days = Calendar.current.dateComponents([.day], from: newPeriod[i], to: newPeriod[i + 1]).day {
                if days <= 1 {
                    newCount += 1
                    if newCount > count {
                        count = newCount
                    }
                } else {
                    if newCount > count {
                        count = newCount
                    }
                    newCount = 1
                }
            }
        }
        return count
    }

    private func idealDays(trackers: [TrackerRecord], category: [TrackerCategory]) -> Int {
        var count = 0
        var completePeriod: [Date: Int] = [:]
        var goalPeriod: [Date: Int] = [:]
        var allTrack: [Tracker] = []
        var period: [Date] = []

        for value in trackers {
            if let date = value.date.ignoringTime  {
                if !period.contains(date) {
                    period.append(date)
                }
                if let counter = completePeriod[date] {
                    completePeriod.updateValue(counter + 1, forKey: date)
                } else {
                    completePeriod.updateValue(1, forKey: date)
                }
            }
        }

        for value in category {
            value.trackers.forEach{
                allTrack.append($0)
            }
        }

        for day in period {
            let weekday = Calendar.current.component(.weekday, from: day)
            for trackValue in allTrack {
                trackValue.schedule.forEach{
                    if weekday == $0.rawValue {
                        if let counter = goalPeriod[day] {
                            goalPeriod.updateValue(counter + 1, forKey: day)
                        } else {
                            goalPeriod.updateValue(1, forKey: day)
                        }
                    }
                }
            }
        }

        for (_, value) in completePeriod.enumerated() {
            if let goalValue = goalPeriod[value.key] {
                if value.value == goalValue {
                    count += 1
                }
            }
        }
        return count
    }

    private func setupBlankView() {
        view.backgroundColor = .ypWhite

        [statisticTableView].forEach { $0.removeFromSuperview() }
        [emptyView, openingLabel].forEach{ view.addSubview($0) }

        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            openingLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
            openingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupView(){
        [emptyView, openingLabel].forEach { $0.removeFromSuperview() }

        view.addSubview(statisticTableView)

        NSLayoutConstraint.activate([
            statisticTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            statisticTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            statisticTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        statisticTableView.reloadData()
    }
}

//MARK: -UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: -UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indicators.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.identifier, for: indexPath) as? StatisticCell else {
            return UITableViewCell()
        }

        let indicator = indicators[indexPath.row]

        cell.setInformation(name: indicator.nameString, count: getCount(indicator: indicator))
        return cell
    }
}
