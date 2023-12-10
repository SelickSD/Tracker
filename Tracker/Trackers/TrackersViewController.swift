//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 30.11.2023.
//

import UIKit

class TrackersViewController: UIViewController {

    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "Star")
        return view
    }()

    private lazy var openingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Что будем отслеживать?"
        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()

    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(TrackersCell.self, forCellWithReuseIdentifier: TrackersCell.identifier)
        view.backgroundColor = .ypWhite
        return view
    }()

    private lazy var searchController = UISearchController(searchResultsController: nil)

    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIBarButtonItem()

        if categories.isEmpty {
            setupBlankView()
        } else {
            setupView()
        }
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Формат даты
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }

    @objc private func addTapped() {

    }

    private func setupBlankView() {
        view.backgroundColor = .ypWhite

        view.addSubview(emptyView)
        view.addSubview(openingLabel)

        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            openingLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor),
            openingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupUIBarButtonItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(addTapped))
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack

        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }

    private func setupView(){

        view.backgroundColor = .ypWhite
        view.addSubview(trackersCollectionView)

    }
}

//MARK: -UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {

}

//MARK: -UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TrackersCell()
        return cell
    }
}
