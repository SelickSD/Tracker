//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 12.03.2024.
//
import UIKit
final class FiltersViewController: UIViewController {
    weak var delegate: FilterViewDelegate?
    private var filters: [Filters] = [.allTrackers, .thisDay, .completedTrackers, .openTrackers]
    private var chooseFilter: Filters = .allTrackers

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
        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegateChange()
    }

    func setupTableView(chooseFilter: Filters) {
        self.chooseFilter = chooseFilter
    }

    private func delegateChange() {
        delegate?.fetchFilter(chooseFilter: chooseFilter)
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubview(pageNameLabel)
        view.addSubview(scheduleTableView)

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            scheduleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
    }

    private func getDoneIndexPath() -> IndexPath? {
        for (index, value) in filters.enumerated() {
            if chooseFilter == value {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }
}

//MARK: -UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let oldDone = getDoneIndexPath() else {
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            return
        }
        if oldDone == indexPath {
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            let first = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CategoriesTableViewCell
            cell?.makeDone()
            first?.makeDone()
            chooseFilter = .allTrackers
        } else {
            let oldCell = tableView.cellForRow(at: oldDone) as? CategoriesTableViewCell
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            oldCell?.makeDone()
            chooseFilter = filters[indexPath.row]
        }
    }
}

//MARK: -UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier, for: indexPath) as? CategoriesTableViewCell else {
            return UITableViewCell()
        }
        cell.configCell(rowOfCell: indexPath.row, maxCount: filters.count, category: filters[indexPath.row].nameString)
        if chooseFilter == filters[indexPath.row]  {
            cell.makeDone()
        }
        if filters.count >= 2 {
            if indexPath.row >= 0 && indexPath.row < filters.count - 1 {
                cell.setSeparatorView()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
