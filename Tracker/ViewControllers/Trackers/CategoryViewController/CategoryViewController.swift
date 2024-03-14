//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 23.01.2024.
//
import UIKit
final class CategoryViewController: UIViewController,
                                    CreateNewCategoryViewControllerDelegate {
    weak var delegate: CategoryViewControllerDelegate?
    private var isCategorySelected = false
    private var viewModel: CategoryViewModelProtocol?

    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.image = UIImage(named: "Star")
        return view
    }()

    private lazy var pageNameLabel: UILabel = {
        let pageName = NSLocalizedString("categoryView.pageName",
                                         comment: "Text displayed like page name")
        let label = UILabel()
        label.clipsToBounds = true
        label.text = pageName
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let description = NSLocalizedString("categoryView.description",
                                            comment: "Text displayed like page description")
        let label = UILabel()
        label.clipsToBounds = true
        label.text = description
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(CategoriesTableViewCell.self,
                           forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let doneButtonName = NSLocalizedString("categoryView.doneButtonName",
                                               comment: "Text displayed like name of Done button")
        let button = UIButton()
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
        view.backgroundColor = .ypWhite
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.delegateChange()
    }

    func initialize(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        bind()
        viewModel.checkInitialStatus()
    }

    func fetchCategoryName(name: String) {
        viewModel?.updateCategory(name: name)
    }

    @objc private func didTapDoneButton() {
        if isCategorySelected {
            viewModel?.delegateChange()
            self.dismiss(animated: true)
        } else {
            let newCategoryViewController = CreateNewCategoryViewController()
            newCategoryViewController.delegate = self
            self.present(newCategoryViewController, animated: true)
        }
    }

    private func bind() {
        guard var viewModel = viewModel else { return }
        viewModel.isCategoryEmpty = { [weak self] isEmpty in
            self?.setupView(isEmpty: isEmpty)
        }
        viewModel.isCategoryUpdated = { [weak self] isCategoryUpdated in
            if isCategoryUpdated {
                self?.categoriesTableView.reloadData()
            }
        }
        viewModel.isCategorySelected = { [weak self] isSelected in
            self?.isCategorySelected = isSelected
        }
    }

    private func setupView(isEmpty: Bool) {
        isEmpty ? setupBlankView() : setupTargetView()
    }

    private func setupBlankView() {
        [emptyView,
         pageNameLabel,
         descriptionLabel,
         doneButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),

            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 288),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupTargetView() {
        [pageNameLabel,
         categoriesTableView,
         doneButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            categoriesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: 10),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

//MARK: -UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        guard let oldDone = viewModel.getDoneIndexPath() else {
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            viewModel.setDoneIndexPath(indexPath: indexPath)
            return
        }
        if oldDone == indexPath {
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            viewModel.setDoneIndexPath(indexPath: nil)
        } else {
            let oldCell = tableView.cellForRow(at: oldDone) as? CategoriesTableViewCell
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            oldCell?.makeDone()
            viewModel.setDoneIndexPath(indexPath: indexPath)
        }
    }
}

//MARK: -UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier,
                                                       for: indexPath) as? CategoriesTableViewCell else {
            return UITableViewCell()
        }
        let numberOfRowsInSection = viewModel.numberOfRowsInSection()
        let category = viewModel.categoryOfIndex(index: indexPath.row)
        let startIndex = viewModel.getStartIndex()
        cell.configCell(rowOfCell: indexPath.row, maxCount: numberOfRowsInSection, category: category)

        if startIndex != nil && indexPath.row == startIndex {
            cell.makeDone()
            viewModel.setDoneIndexPath(indexPath: indexPath)
        }
        if numberOfRowsInSection >= 2 {
            if indexPath.row >= 0 && indexPath.row < numberOfRowsInSection - 1 {
                cell.setSeparatorView()
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
