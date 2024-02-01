//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 30.11.2023.
//

import UIKit

final class TrackersViewController: UIViewController, 
                                    TrackersCellDelegate,
                                    TrackersViewControllerDelegate {
    
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return datePicker
    }()
    
    private lazy var backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(TrackersCell.self, forCellWithReuseIdentifier: TrackersCell.identifier)
        view.register(HeaderCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCellView.identifier)
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private var filterDateCategories: [TrackerCategory] = []
    private var isBlankView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIBarButtonItem()
        updateFilterCategories()
        
        if filterDateCategories.isEmpty {
            setupBlankView()
            isBlankView = true
        } else {
            setupView()
            isBlankView = false
        }
    }
    
    func didTapPlusButton(id: UUID) {
        completedTrackers.append(TrackerRecord(id: id, date: currentDate))
    }
    
    func didUnTapPlusButton(id: UUID) {
        let oldTracks = completedTrackers
        var index = 0
        
        for items in oldTracks {
            if items.id == id && Calendar.current.component(.day, from: items.date) == Calendar.current.component(.day, from: currentDate) {
                completedTrackers.remove(at: index)
            }
            index += 1
        }
    }
    
    func fetchNewTrack(newHabit: TrackerCategory) {
        updateCategory(newHabit: newHabit)
        updateFilterCategories()
        checkView()
        trackersCollectionView.reloadData()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = selectedDate
        updateFilterCategories()
        checkView()
        trackersCollectionView.reloadData()
    }
    
    @objc private func addTapped() {
        let createNewTrackerViewController = CreateNewTrackerViewController()
        createNewTrackerViewController.delegate = self
        categories.forEach({ value in
            createNewTrackerViewController.categories.append(value.name)
        })
        self.present(createNewTrackerViewController, animated: true)
    }
    
    private func checkView() {
        if filterDateCategories.isEmpty && !isBlankView {
            setupBlankView()
            isBlankView = true
        } else if !filterDateCategories.isEmpty && isBlankView {
            setupView()
            isBlankView = false
        }
    }
    
    private func updateCategory(newHabit: TrackerCategory) {
        let oldCategory = categories
        var isChange = false
        var index = 0
        
        oldCategory.forEach({ value in
            if value.name == newHabit.name {
                var trackers = categories[index].trackers
                trackers.append(newHabit.trackers[0])
                categories.remove(at: index)
                categories.insert(TrackerCategory(name: value.name, trackers: trackers), at: index)
                isChange.toggle()
            }
            index += 1
        })
        
        if !isChange {
            categories.append(newHabit)
        }
    }
    
    private func setupBlankView() {
        view.backgroundColor = .ypWhite
        
        backgroundScrollView.removeFromSuperview()
        contentView.removeFromSuperview()
        trackersCollectionView.removeFromSuperview()
        
        view.addSubview(emptyView)
        view.addSubview(openingLabel)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            openingLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
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
        
        emptyView.removeFromSuperview()
        openingLabel.removeFromSuperview()
        
        view.addSubview(backgroundScrollView)
        backgroundScrollView.addSubview(contentView)
        contentView.addSubview(trackersCollectionView)
        
        let equalHeight = contentView.heightAnchor.constraint(equalToConstant: 850)
        equalHeight.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            backgroundScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            equalHeight,
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateFilterCategories() {
        filterDateCategories = []
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        var tracks: [Tracker] = []
        
        categories.forEach({ category in
            category.trackers.forEach({ track in
                track.schedule.forEach({ dayOfWeek in
                    if weekday == dayOfWeek.rawValue {
                        tracks.append(track)
                    }
                })
            })
            if !tracks.isEmpty {
                filterDateCategories.append(TrackerCategory(name: category.name, trackers: tracks))
            }
            tracks = []
        })
    }
    
    private func configCell(for cell: TrackersCell, with indexPath: IndexPath) {
        var isCompleted = false
        let trackForCategory = filterDateCategories[indexPath.section].trackers[indexPath.row]
        var count = 0
        var isEnabled = true
        
        completedTrackers.forEach({ track in
            if track.id == trackForCategory.id && Calendar.current.component(.day, from: track.date) == Calendar.current.component(.day, from: currentDate) {
                isCompleted = true
            }
        })
        
        completedTrackers.forEach({ track in
            if track.id == trackForCategory.id {
                count += 1
            }
        })
        
        if Calendar.current.component(.day, from: currentDate) > Calendar.current.component(.day, from: Date()) {
            isEnabled = false
        }
        
        cell.configCell(track: trackForCategory, isCompleted: isCompleted, count: count, isEnabled: isEnabled)
    }
}

//MARK: -UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    private var params: GeometricParams {
        return GeometricParams(cellCount: 2,
                               leftInset: 10,
                               rightInset: 10,
                               cellSpacing: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSize(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: params.cellSpacing,
                     left: params.leftInset,
                     bottom: params.cellSpacing,
                     right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let size = getSize(collectionView: collectionView)
        return CGSize(width: size.width, height: size.height / 5)
    }
    
    private func getSize(collectionView: UICollectionView) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth,
                      height: cellWidth * 2 / 2)
    }
}

//MARK: -UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in: UICollectionView) -> Int {
        return filterDateCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterDateCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCell.identifier, for: indexPath) as? TrackersCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        configCell(for: cell, with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCellView.identifier, for: indexPath) as? HeaderCellView else {
            return UICollectionReusableView()
        }
        
        view.prepareView(name: filterDateCategories[indexPath.section].name)
        return view
    }
}
