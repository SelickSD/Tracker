//
//  CreateNewHabitViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.12.2023.
//
import UIKit
final class CreateNewHabitViewController: UIViewController,
                                          CategoryViewControllerDelegate,
                                          ScheduleViewControllerDelegate,
                                          CreateNewHabitProtocol {

    var isEvent = false
    weak var delegate: TrackersViewControllerDelegate?
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
    ]
    private let colours = [
        "FD4C49", "FF881E", "007BFA", "6E44FE", "33CF69", "E66DD4",
        "F9D4D4", "34A7FE", "46E69D", "35347C", "FF674D", "FF99CC",
        "F6C48B", "7994F5", "832CF1", "AD56DA", "8D72E6", "2FD058"
    ]
    private let dayOfWeek: [DayOfWeek] = [.monday, .tuesday, .wednesday,
                                          .thursday, .friday, .saturday, .sunday]
    private var configCells: [String: IndexPath] = [:]
    private var newTrackerName: String?
    private var category: Int?
    private var choseDay: [DayOfWeek] = []
    private var categories: [String] = []
    private var trackerID: UUID?

    private lazy var pageNameLabel: UILabel = {
        let pageName = NSLocalizedString("createNewHabitView.pageName",
                                         comment: "Text displayed like page name")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = pageName
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
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

    private lazy var tapGestureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var habitTextField: UITextField = {
        let textFieldPlaceholder = NSLocalizedString("createNewHabitView.textField.placeholder",
                                                     comment: "Text displayed like placeholder")
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.placeholder = textFieldPlaceholder
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textAlignment = NSTextAlignment.left
        textField.layer.cornerRadius = 16
        textField.indent(size: 16)
        textField.delegate = self
        textField.addTarget(self, action: #selector(habitTextChanged), for: .editingChanged)
        return textField
    }()

    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()

    private lazy var presentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(PresentViewCell.self, forCellWithReuseIdentifier: PresentViewCell.identifier)
        view.register(ColorViewCell.self, forCellWithReuseIdentifier: ColorViewCell.identifier)
        view.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        view.allowsMultipleSelection = false
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let cancelButtonName = NSLocalizedString("createNewHabitView.cancelButtonName",
                                                 comment: "Text displayed like name of cance button")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 16
        button.setTitle(cancelButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    private lazy var createButton: UIButton = {
        let createButtonName = NSLocalizedString("createNewHabitView.createButtonName",
                                                 comment: "Text displayed like name of create button")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.setTitle(createButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupGestures()
    }

    func configViewForEdit(trackerCategory: TrackerCategory, categories: [String]) {
        habitTextField.text = trackerCategory.trackers[0].name
        newTrackerName = trackerCategory.trackers[0].name
        self.categories = categories
        trackerID = trackerCategory.trackers[0].id
        choseDay = trackerCategory.trackers[0].schedule
        var colorIndex = 0
        var emojiIndex = 0
        var categoryIndex = 0

        for (index, value) in emojis.enumerated() {
            if trackerCategory.trackers[0].emoji == value {
                emojiIndex = index
            }
        }

        for (index, value) in colours.enumerated() {
            let color = UIColor(hex: value)
            if trackerCategory.trackers[0].color == color {
                colorIndex = index
            }
        }

        for value in categories {
            if trackerCategory.name == value {
                category = categoryIndex
            }
            categoryIndex += 1
        }

        configCells.updateValue(IndexPath(row: emojiIndex, section: 0), forKey: "Emoji")
        configCells.updateValue(IndexPath(row: colorIndex, section: 1), forKey: "Цвет")

        checkWellDone()
        presentCollectionView.reloadData()
        mainTableView.reloadData()
    }

    func fetchCategory(index: Int?, categories: [String]) {
        self.categories = categories
        category = index
        mainTableView.reloadData()
        checkWellDone()
    }

    func fetchDayOfWeek(dayOfWeek: [DayOfWeek]) {
        self.choseDay = dayOfWeek
        mainTableView.reloadData()
        checkWellDone()
    }

    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }

    @objc private func didTapCreateButton() {
        guard let name = newTrackerName,
              let colorIndex = configCells["Цвет"]?.row,
              let emojiIndex = configCells["Emoji"]?.row,
              let categoryIndex = category,
              let color = UIColor(hex: colours[colorIndex]),
              !choseDay.isEmpty else {return}

        let newHabit = Tracker(id: trackerID ?? UUID(),
                               name: name,
                               color: color,
                               emoji: emojis[emojiIndex],
                               schedule: choseDay)

        let trackerCategory = TrackerCategory(name: categories[categoryIndex],
                                              trackers: [newHabit])

        delegate?.fetchNewTrack(newHabit: trackerCategory)
        self.dismiss(animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func habitTextChanged(_ textField: UITextField) {
        newTrackerName = textField.text
        checkWellDone()
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        tapGestureView.addGestureRecognizer(tapGesture)
    }

    private func checkWellDone() {
        guard newTrackerName != nil,
              let colorIndex = configCells["Цвет"]?.row,
              configCells["Emoji"]?.row != nil,
              category != nil,
              UIColor(hex: colours[colorIndex]) != nil,
              !choseDay.isEmpty else {return}

        createButton.backgroundColor = .ypBlack
        createButton.isEnabled = true
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubview(backgroundScrollView)
        view.addSubview(pageNameLabel)
        backgroundScrollView.addSubview(contentView)
        contentView.addSubview(mainTableView)
        contentView.addSubview(tapGestureView)
        tapGestureView.addSubview(habitTextField)
        contentView.addSubview(presentCollectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)

        let equalHeight = contentView.heightAnchor.constraint(equalToConstant: 850)
        equalHeight.priority = UILayoutPriority(250)
        var mainTableViewHeightAnchor = mainTableView.heightAnchor.constraint(equalToConstant: 210)

        if isEvent {
            mainTableViewHeightAnchor = mainTableView.heightAnchor.constraint(equalToConstant: 110)
            choseDay = [
                .monday, .tuesday, .wednesday,
                .thursday, .friday, .saturday, .sunday]
        }

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            backgroundScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 102),
            backgroundScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: backgroundScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: backgroundScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: backgroundScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: backgroundScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            equalHeight,

            tapGestureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tapGestureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tapGestureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tapGestureView.heightAnchor.constraint(equalToConstant: 120),

            habitTextField.topAnchor.constraint(equalTo: tapGestureView.topAnchor),
            habitTextField.leadingAnchor.constraint(equalTo: tapGestureView.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: tapGestureView.trailingAnchor, constant: -16),
            habitTextField.heightAnchor.constraint(equalToConstant: 75),

            mainTableView.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 10),
            mainTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainTableViewHeightAnchor,

            presentCollectionView.topAnchor.constraint(equalTo: mainTableView.bottomAnchor, constant: 10),
            presentCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            presentCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            presentCollectionView.heightAnchor.constraint(equalToConstant: 420),

            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: presentCollectionView.bottomAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),

            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            createButton.topAnchor.constraint(equalTo: presentCollectionView.bottomAnchor, constant: 20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8)
        ])
    }

    private func createTextLabel() -> String {
        var text = ""
        dayOfWeek.forEach({ value in
            if choseDay.contains(value) {
                text = text + value.shortName + ", "
            }
        })
        return String(text.dropLast(2))
    }
}

//MARK: -UITextFieldDelegate
extension CreateNewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

//MARK: -UITableViewDelegate
extension CreateNewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        switch indexPath.row {
        case 0:
            let categoryViewController = CategoryViewController()
            let categoryModel = TrackerCategoryStore()
            let viewModel = CategoryViewModel(for: categoryModel, index: category)
            viewModel.delegate = self
            categoryViewController.initialize(viewModel: viewModel)
            self.present(categoryViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            scheduleViewController.setupTableView(choseDay: choseDay)
            self.present(scheduleViewController, animated: true)
        default:
            break
        }
    }
}

//MARK: -UITableViewDataSource
extension CreateNewHabitViewController: UITableViewDataSource {
    private var maxRows: Int {
        if isEvent {
            return 1
        }
        return 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }

        switch indexPath.row {
        case 0:
            if let index = category {
                cell.configLabel(newLabelText: categories[index])
            } else {
                cell.discardChanges()
            }
        case 1:
            if choseDay.isEmpty {
                cell.discardChanges()
            } else {
                cell.configLabel(newLabelText: createTextLabel())
            }
        default:
            break
        }
        cell.configCell(rowOfCell: indexPath.row, maxCount: maxRows)
        if !isEvent{
            if indexPath.row == 0 {
                cell.setSeparatorView()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

//MARK: -UICollectionViewDelegateFlowLayout
extension CreateNewHabitViewController: UICollectionViewDelegateFlowLayout {
    private var params: GeometricParams {
        return GeometricParams(cellCount: 2,
                               leftInset: 10,
                               rightInset: 10,
                               cellSpacing: 10)
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
extension CreateNewHabitViewController: UICollectionViewDataSource {
    func numberOfSections(in: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojis.count
        case 1:
            return colours.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PresentViewCell.identifier, for: indexPath) as? PresentViewCell else {
                return UICollectionViewCell()
            }
            if !configCells.isEmpty {
                if indexPath.row == configCells["Emoji"]?.row {
                    cell.backgroundColor = .ypBackgroundGrey
                }
            }

            cell.configLabel(text: emojis[indexPath.row])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.identifier, for: indexPath) as? ColorViewCell else {
                return UICollectionViewCell()
            }
            if !configCells.isEmpty {
                if indexPath.row == configCells["Цвет"]?.row {
                    cell.setColorOn(color: colours[indexPath.row])
                    return cell
                }
            }
            cell.setColorOff(color: colours[indexPath.row])
            return cell
        default:
            break
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        let cellEmojiName = NSLocalizedString("createNewHabitView.cellEmojiName", comment: "Text displayed like cell name")
        let cellColorName = NSLocalizedString("createNewHabitView.cellColorName", comment: "Text displayed like cell name")

        switch indexPath.section {
        case 0:
            view.titleLabel.text = cellEmojiName
        case 1:
            view.titleLabel.text = cellColorName
        default:
            break
        }
        return view
    }
}

extension CreateNewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        let tmpConfig = configCells

        switch indexPath.section {
        case 0:
            configCells.updateValue(indexPath, forKey: "Emoji")
        case 1:
            configCells.updateValue(indexPath, forKey: "Цвет")
        default:
            break
        }
        checkWellDone()
        for (key, value) in configCells {
            if tmpConfig[key] != value && key == "Emoji" {
                guard let index = tmpConfig[key] else {
                    let cell = collectionView.cellForItem(at: value) as? PresentViewCell
                    cell?.backgroundColor = .ypBackgroundGrey
                    return
                }
                let tmpCell = collectionView.cellForItem(at: index) as? PresentViewCell
                let cell = collectionView.cellForItem(at: value) as? PresentViewCell
                tmpCell?.backgroundColor = .white
                cell?.backgroundColor = .ypBackgroundGrey
            } else if tmpConfig[key] != value && key == "Цвет" {
                guard let index = tmpConfig[key] else {
                    let cell = collectionView.cellForItem(at: value) as? ColorViewCell
                    cell?.setColorOn(color: colours[value.row])
                    return
                }
                let tmpCell = collectionView.cellForItem(at: index) as? ColorViewCell
                let cell = collectionView.cellForItem(at: value) as? ColorViewCell
                tmpCell?.setColorOff(color: colours[index.row])
                cell?.setColorOn(color: colours[value.row])
            }
        }
    }
}
