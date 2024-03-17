//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 30.11.2023.
//
import UIKit
final class TrackersViewController: UIViewController,
                                    TrackersCellDelegate,
                                    TrackersViewControllerDelegate,
                                    UIGestureRecognizerDelegate,
                                    UISearchBarDelegate,
                                    FilterViewDelegate {

    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private var filterDateCategories: [TrackerCategory] = []
    private var isBlankView = false
    private var currentTracker = ""
    private var fixedTrackers: [Tracker] = []
    private var chooseFilter: Filters = .allTrackers

    private lazy var dataProvider: DataProviderProtocol? = {
        return DataProvider()
    }()

    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "Star")
        return view
    }()

    private lazy var openingLabel: UILabel = {
        let openingLabelText = NSLocalizedString("trackerView.openingLabelText",
                                                 comment: "Text displayed like page description")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = openingLabelText
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
        view.register(HeaderCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: HeaderCellView.identifier)
        view.backgroundColor = .ypWhite
        return view
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBarPlaceholder = NSLocalizedString("trackerView.searchBar.placeholder",
                                                     comment: "Text displayed like placeholder")
        let view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.barTintColor = UIColor.white
        view.setBackgroundImage(UIImage.init(), for: UIBarPosition.any,
                                barMetrics: UIBarMetrics.default)
        view.placeholder = searchBarPlaceholder
        view.delegate = self
        return view
    }()

    private lazy var filtersButton: UIButton = {
        let createHabitButtonName = NSLocalizedString("trackerView.filterButtonName",
                                                      comment: "Text displayed like name of filter button")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = Colors().buttonDisabledColor
        button.tintColor = .ypWhite
        button.setTitle(createHabitButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        return button
    }()

    private lazy var clearFiltersButton: UIButton = {
        let createHabitButtonName = NSLocalizedString("trackerView.filterButtonName",
                                                      comment: "Text displayed like name of filter button")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = Colors().buttonDisabledColor
        button.tintColor = .ypWhite
        button.setTitle(createHabitButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCategoriesFromCoreData()
        setupUIBarButtonItem()
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        setupGestures()

        if filterDateCategories.isEmpty {
            setupBlankView()
            isBlankView = true
        } else {
            setupView()
            isBlankView = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.report(event: "open", params: ["screen":"Main"])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.report(event: "close", params: ["screen":"Main"])
    }

    func presentView(vc: CreateNewHabitProtocol) {
        guard let viewController = vc as? CreateNewHabitViewController else {return}
        viewController.delegate = self
        self.present(viewController, animated: true)
    }

    func didTapPlusButton(id: UUID) {
        AnalyticsService.report(event: "click", params: ["track": "Main"])
        completedTrackers.append(TrackerRecord(id: id, date: currentDate))
        dataProvider?.addRecord(record: TrackerRecord(id: id, date: currentDate))
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        trackersCollectionView.reloadData()
    }

    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let selectedText = searchBar.text else { return }
        currentTracker = selectedText
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentTracker = searchText
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    func didUnTapPlusButton(id: UUID) {
        let oldTracks = completedTrackers
        var index = 0

        for items in oldTracks {
            if items.id == id && Calendar.current.component(.day, from: items.date) == Calendar.current.component(.day, from: currentDate) {
                dataProvider?.deleteRecord(record: completedTrackers[index])
                completedTrackers.remove(at: index)
            }
            index += 1
        }
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        trackersCollectionView.reloadData()
    }

    func fetchNewTrack(newHabit: TrackerCategory) {
        dataProvider?.editTrackerID(tracker: newHabit.trackers[0])
        updateCategory(newHabit: newHabit)
        updateCategoriesFromCoreData()
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    @objc private func didTapFiltersButton() {
        AnalyticsService.report(event: "click", params: ["filter": "Main"])
        let filterView = FiltersViewController()
        filterView.delegate = self
        filterView.setupTableView(chooseFilter: chooseFilter)
        self.present(filterView, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = selectedDate
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    @objc private func addTapped() {
        AnalyticsService.report(event: "click", params: ["add_track": "Main"])
        resetCurrentDate()
        let createNewTrackerViewController = CreateNewTrackerViewController()
        createNewTrackerViewController.delegate = self
        self.present(createNewTrackerViewController, animated: true)
    }

    func fetchFilter(chooseFilter: Filters) {
        self.chooseFilter = chooseFilter
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }

    private func checkView() {
        if filterDateCategories.isEmpty && !isBlankView {
            setupBlankView()
            isBlankView = true
        } else if !filterDateCategories.isEmpty && isBlankView {
            setupView()
            isBlankView = false
        } else if filterDateCategories.isEmpty && isBlankView {
            setupBlankView()
        }
    }

    private func resetCurrentDate() {
        datePicker.date = Date()
        currentDate = Date()
        trackersCollectionView.reloadData()
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
                dataProvider?.addNewTracker(tracker: newHabit.trackers[0], toCategoryName: value.name)
                isChange.toggle()
            }
            index += 1
        })

        if !isChange {
            categories.append(newHabit)
            dataProvider?.addNewCategory(category: newHabit)
        }
    }

    private func setupBlankView() {
        view.backgroundColor = .ypWhite
        [backgroundScrollView,
         contentView,
         trackersCollectionView,
         filtersButton].forEach { $0.removeFromSuperview() }

        if chooseFilter == .allTrackers && currentTracker.isEmpty {
            let openingLabelText = NSLocalizedString("trackerView.openingLabelText",
                                                     comment: "Text displayed like page description")
            let image = UIImage(named: "Star")
            emptyView.image = image
            openingLabel.text = openingLabelText

            [emptyView,
             openingLabel].forEach{ view.addSubview($0) }

            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

                openingLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
                openingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            let openingLabelText = NSLocalizedString("trackerView.openingLabelTextWithFilter",
                                                     comment: "Text displayed like page description")
            let image = UIImage(named: "Filter")
            emptyView.image = image
            openingLabel.text = openingLabelText

            [clearFiltersButton, emptyView,
             openingLabel].forEach{ view.addSubview($0) }

            NSLayoutConstraint.activate([
                clearFiltersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                clearFiltersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                clearFiltersButton.heightAnchor.constraint(equalToConstant: 50),
                clearFiltersButton.widthAnchor.constraint(equalToConstant: 114),

                emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

                openingLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
                openingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

    private func setupUIBarButtonItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(addTapped))
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }

    private func setupView(){
        [emptyView,
         openingLabel, clearFiltersButton].forEach { $0.removeFromSuperview() }

        view.addSubview(backgroundScrollView)
        view.addSubview(filtersButton)
        backgroundScrollView.addSubview(contentView)
        contentView.addSubview(trackersCollectionView)

        let equalHeight = contentView.heightAnchor.constraint(equalToConstant: 850)
        equalHeight.priority = UILayoutPriority(250)

        NSLayoutConstraint.activate([
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),

            backgroundScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            equalHeight,

            trackersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            trackersCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func updateFilterCategories() {
        filterDateCategories = []
        var tracks: [Tracker] = []

        switch chooseFilter {
        case .allTrackers:
            for value in categories {
                if !value.trackers.isEmpty {
                    let tempTrackers = checkTrackers(trackers: value.trackers)
                    if !tempTrackers.isEmpty {
                        filterDateCategories.append(TrackerCategory(name: value.name, trackers: tempTrackers))
                    }
                }
            }
        case .completedTrackers:
            var trackerID: [UUID] = []
            guard let currentPeriod = currentDate.ignoringTime else {return}
            completedTrackers.forEach{
                if let newPeriod = $0.date.ignoringTime {
                    if Calendar.current.compare(newPeriod, to: currentPeriod, toGranularity: .day) == .orderedSame {
                        trackerID.append($0.id)
                    }
                }
            }
            for category in categories {
                for tracker in category.trackers {
                    if trackerID.contains(tracker.id) {
                        tracks.append(tracker)
                    }
                }
                if !tracks.isEmpty {
                    let tmpTrackers = checkTrackers(trackers: tracks)
                    if !tmpTrackers.isEmpty {
                        filterDateCategories.append(TrackerCategory(name: category.name, trackers: tracks))
                    }
                    tracks = []
                }
            }
        case .openTrackers:
            var trackerID: [UUID] = []
            guard let currentPeriod = currentDate.ignoringTime else {return}
            completedTrackers.forEach{
                if let newPeriod = $0.date.ignoringTime {
                    if Calendar.current.compare(newPeriod, to: currentPeriod, toGranularity: .day) == .orderedSame {
                        trackerID.append($0.id)
                    }
                }
            }
            for category in categories {
                for tracker in category.trackers {
                    if !trackerID.contains(tracker.id) {
                        tracks.append(tracker)
                    }
                }
                if !tracks.isEmpty {
                    let tmpTrackers = checkTrackers(trackers: tracks)
                    if !tmpTrackers.isEmpty {
                        filterDateCategories.append(TrackerCategory(name: category.name, trackers: tracks))
                    }
                    tracks = []
                }
            }
        case .thisDay:
            categories.forEach({ category in
                tracks = checkTrackers(trackers: category.trackers)
                if !tracks.isEmpty {
                    filterDateCategories.append(TrackerCategory(name: category.name, trackers: tracks))
                    tracks = []
                }
            })
        }
    }

    private func configFilterCategoriesWithFixedTrackers() {
        guard !fixedTrackers.isEmpty else {return}
        let checkTracks = checkTrackers(trackers: fixedTrackers)
        let tracks = checkFilters(trackers: checkTracks)
        guard !tracks.isEmpty else {return}
        let fixCategoryName = NSLocalizedString("trackerView.fixedCategoryName", comment: "Fixed Category name")
        let oldFilterCategories = filterDateCategories
        var tempTrackers: [Tracker] = []
        var trackerUUIDs: [UUID] = []
        tracks.forEach{trackerUUIDs.append($0.id)}
        filterDateCategories = []
        filterDateCategories.append(TrackerCategory(name: fixCategoryName, trackers: tracks))

        for category in oldFilterCategories {
            for tracker in category.trackers {
                if !trackerUUIDs.contains(tracker.id) {
                    tempTrackers.append(tracker)
                }
            }
            if !tempTrackers.isEmpty {
                filterDateCategories.append(TrackerCategory(name: category.name, trackers: tempTrackers))
                tempTrackers = []
            }
        }
    }

    private func checkFilters(trackers: [Tracker]) -> [Tracker] {
        var tracks: [Tracker] = []
        switch chooseFilter {
        case .allTrackers:
            tracks = trackers
        case .completedTrackers:
            var trackerID: [UUID] = []
            guard let currentPeriod = currentDate.ignoringTime else {return []}
            completedTrackers.forEach{
                if let newPeriod = $0.date.ignoringTime {
                    if Calendar.current.compare(newPeriod, to: currentPeriod, toGranularity: .day) == .orderedSame {
                        trackerID.append($0.id)
                    }
                }
            }
            for tracker in trackers {
                if trackerID.contains(tracker.id) {
                    tracks.append(tracker)
                }
            }
        case .openTrackers:
            var trackerID: [UUID] = []
            guard let currentPeriod = currentDate.ignoringTime else {return []}
            completedTrackers.forEach{
                if let newPeriod = $0.date.ignoringTime {
                    if Calendar.current.compare(newPeriod, to: currentPeriod, toGranularity: .day) == .orderedSame {
                        trackerID.append($0.id)
                    }
                }
            }
            for tracker in trackers {
                if !trackerID.contains(tracker.id) {
                    tracks.append(tracker)
                }
            }
        case .thisDay:
            tracks = trackers
        }
        return tracks
    }

    private func checkTrackers(trackers: [Tracker]) -> [Tracker] {
        var tracks: [Tracker] = []
        let weekday = Calendar.current.component(.weekday, from: currentDate)

        if currentTracker.isEmpty {
            trackers.forEach({ track in
                track.schedule.forEach({ dayOfWeek in
                    if weekday == dayOfWeek.rawValue {
                        tracks.append(track)
                    }
                })
            })
        } else {
            trackers.forEach({ track in
                if track.name == currentTracker {
                    track.schedule.forEach({ dayOfWeek in
                        if weekday == dayOfWeek.rawValue {
                            tracks.append(track)
                        }
                    })
                }
            })
        }
        return tracks
    }

    private func configCell(for cell: TrackersCell, with indexPath: IndexPath) {
        var isCompleted = false
        let trackForCategory = filterDateCategories[indexPath.section].trackers[indexPath.row]
        var count = 0
        var isEnabled = true
        var isFix = false
        var fixId: [UUID] = []

        fixedTrackers.forEach{
            fixId.append($0.id)
        }

        if fixId.contains(trackForCategory.id) {
            isFix = true
        }

        completedTrackers.forEach({ track in
            if track.id == trackForCategory.id && Calendar.current.dateComponents([.year, .month, .day], from: track.date) == Calendar.current.dateComponents([.year, .month, .day], from: currentDate) {
                isCompleted = true
            }
        })

        completedTrackers.forEach({ track in
            if track.id == trackForCategory.id {
                count += 1
            }
        })

        if let date1 = currentDate.ignoringTime {
            if let date2 = Date().ignoringTime {
                if Calendar.current.compare(date1, to: date2, toGranularity: .day) == .orderedDescending {
                    isEnabled = false
                }
            }
        }

        cell.configCell(track: trackForCategory,
                        isCompleted: isCompleted,
                        count: count,
                        isEnabled: isEnabled,
                        isFix: isFix)
    }

    private func showMessage(title: String, message: String, buttonName: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: buttonName, style: .destructive, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
    }

    private func updateCategoriesFromCoreData() {
        guard let objects = dataProvider?.getObjects(),
              let category = objects.0,
              let records = objects.1,
              let fixed = objects.2 else {return}
        categories = category
        completedTrackers = records
        fixedTrackers = fixed
    }

    private func fixTracker(indexPath: IndexPath) {
        let tracker = filterDateCategories[indexPath.section].trackers[indexPath.row]
        dataProvider?.fixTracker(tracker: tracker)
        fixedTrackers.append(tracker)
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    private func editTracker(indexPath: IndexPath) {
        AnalyticsService.report(event: "click", params: ["edit": "Main"])
        let tracker = filterDateCategories[indexPath.section].trackers[indexPath.row]
        let newHabitViewController = CreateNewHabitViewController()
        newHabitViewController.delegate = self
        var categoryNames: [String] = []
        categories.forEach{
            categoryNames.append($0.name)
        }
        guard let editCategory = getCategory(tracker: tracker) else {return}
        newHabitViewController.configViewForEdit(trackerCategory: TrackerCategory(name: editCategory,
                                                                                  trackers: [tracker]), categories: categoryNames)
        self.present(newHabitViewController, animated: true)
    }

    private func deleteTracker(indexPath: IndexPath) {
        AnalyticsService.report(event: "click", params: ["delete": "Main"])
        let tracker = filterDateCategories[indexPath.section].trackers[indexPath.row]

        dataProvider?.deleteTracker(tracker: tracker)
        updateCategoriesFromCoreData()
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    private func unFixTracker(indexPath: IndexPath) {
        let tracker = filterDateCategories[indexPath.section].trackers[indexPath.row]
        var index = 0
        fixedTrackers.forEach({ value in
            if value.id == tracker.id {
                fixedTrackers.remove(at: index)
            } else {
                index += 1
            }
        })
        dataProvider?.unFixTracker(tracker: tracker)
        updateFilterCategories()
        configFilterCategoriesWithFixedTrackers()
        checkView()
        trackersCollectionView.reloadData()
    }

    private func getCategory(tracker: Tracker) -> String? {
        for (index, value) in categories.enumerated() {
            for tracks in value.trackers {
                if tracks.id == tracker.id {
                    return categories[index].name
                }
            }
        }
        return nil
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
                      height: 148)
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

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCell.identifier,
                                                            for: indexPath) as? TrackersCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        configCell(for: cell, with: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderCellView.identifier,
                                                                         for: indexPath) as? HeaderCellView else {
            return UICollectionReusableView()
        }

        view.prepareView(name: filterDateCategories[indexPath.section].name)
        return view
    }
}

//MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                        point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }

        let fix = NSLocalizedString("trackerView.uiMenu.fix",
                                    comment: "Text displayed context menu settings")
        let unFix = NSLocalizedString("trackerView.uiMenu.unFix",
                                      comment: "Text displayed context menu settings")
        let edit = NSLocalizedString("trackerView.uiMenu.edit",
                                     comment: "Text displayed context menu settings")
        let delete = NSLocalizedString("trackerView.uiMenu.delete",
                                       comment: "Text displayed context menu settings")
        let deleteMassage = NSLocalizedString("trackerView.uiMenu.deleteMessage",
                                              comment: "Text displayed in alarm")
        let cancelButtonName = NSLocalizedString("createNewHabitView.cancelButtonName",
                                                 comment: "Text displayed like name of cance button")

        let indexPath = indexPaths[0]

        var trackerUUIDs: [UUID] = []
        fixedTrackers.forEach{trackerUUIDs.append($0.id)}

        if trackerUUIDs.contains(filterDateCategories[indexPath.section].trackers[indexPath.row].id) {
            return UIContextMenuConfiguration(actionProvider: { actions in
                return UIMenu(children: [
                    UIAction(title: unFix) { [weak self] _ in
                        self?.unFixTracker(indexPath: indexPath)
                    },
                    UIAction(title: edit) { [weak self] _ in
                        self?.editTracker(indexPath: indexPath)
                    },
                    UIAction(title: delete, attributes: .destructive) { [weak self] _ in
                        let alert = UIAlertController(title: "", message: deleteMassage, preferredStyle: .actionSheet)
                        let deleteButton = UIAlertAction(title: delete, style: .destructive, handler: { _ in
                            self?.deleteTracker(indexPath: indexPath)
                        })
                        let canselButton = UIAlertAction(title: cancelButtonName, style: .cancel, handler: { _ in })
                        alert.addAction(deleteButton)
                        alert.addAction(canselButton)
                        self?.present(alert, animated: true, completion: nil)
                    },
                ])
            })
        } else {
            return UIContextMenuConfiguration(actionProvider: { actions in
                return UIMenu(children: [
                    UIAction(title: fix) { [weak self] _ in
                        self?.fixTracker(indexPath: indexPath)
                    },
                    UIAction(title: edit) { [weak self] _ in
                        self?.editTracker(indexPath: indexPath)
                    },
                    UIAction(title: delete, attributes: .destructive) { [weak self] _ in
                        let alert = UIAlertController(title: "", message: deleteMassage, preferredStyle: .actionSheet)
                        let deleteButton = UIAlertAction(title: delete, style: .destructive, handler: { _ in
                            self?.deleteTracker(indexPath: indexPath)
                        })
                        let canselButton = UIAlertAction(title: cancelButtonName, style: .cancel, handler: { _ in })
                        alert.addAction(deleteButton)
                        alert.addAction(canselButton)
                        self?.present(alert, animated: true, completion: nil)
                    },
                ])
            })
        }
    }
}
