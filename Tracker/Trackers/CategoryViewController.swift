//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 23.01.2024.
//

import UIKit

final class CategoryViewController: UIViewController, CategoryViewControllerProtocol, CreateNewCategoryViewControllerDelegate {

    weak var delegate: CategoryViewControllerDelegate?
    private var categories: [String] = []
    private var doneIndex: IndexPath?
    private var myCell: UITableViewCell?
    private var index: Int?

    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "Star")
        return view
    }()

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Категория"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Привычки и события можно объединять по смыслу"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle("Добавить категорию", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegateChange()
    }

    func setupView(category: [String], targetCell: UITableViewCell, index: Int? = nil) {
        myCell = targetCell
        categories = category
        self.index = index

        if categories.isEmpty {
            setupBlankView()
        } else {
            setupTargetView()
        }
    }

    func fetchCategoryName(name: String) {
        categories.append(name)
        if !categories.isEmpty {
            categoriesTableView.reloadData()
            setupTargetView()
        }
    }

    @objc private func didTapDoneButton() {
        if doneIndex != nil {
            delegateChange()
            self.dismiss(animated: true)
        } else {
            let newCategoryViewController = CreateNewCategoryViewController()
            newCategoryViewController.delegate = self
            self.present(newCategoryViewController, animated: true)
        }
    }

    private func delegateChange() {
        guard let targetCell = myCell as? MainTableViewCell else {return}
        guard let done = doneIndex else {
            targetCell.discardChanges()
            delegate?.fetchCategory(index: nil, categories: categories)
            return
        }
        targetCell.configLabel(newLabelText: categories[done.row])
        delegate?.fetchCategory(index: done.row, categories: categories)
    }

    private func setupBlankView() {
        view.backgroundColor = .ypWhite
        view.addSubview(emptyView)
        view.addSubview(pageNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(doneButton)

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
        view.backgroundColor = .ypWhite
        view.addSubview(pageNameLabel)
        view.addSubview(categoriesTableView)
        view.addSubview(doneButton)

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
        guard let oldDone = doneIndex else {
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            doneIndex = indexPath
            return
        }

        if oldDone == indexPath {
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            doneIndex = nil
            index = nil
        } else {
            let oldCell = tableView.cellForRow(at: oldDone) as? CategoriesTableViewCell
            let cell = tableView.cellForRow(at: indexPath) as? CategoriesTableViewCell
            cell?.makeDone()
            oldCell?.makeDone()
            doneIndex = indexPath
        }
    }
}

//MARK: -UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier, for: indexPath) as? CategoriesTableViewCell else {
            return UITableViewCell()
        }
        cell.configCell(rowOfCell: indexPath.row, maxCount: categories.count, category: categories[indexPath.row])

        if index != nil && indexPath.row == index {
            cell.makeDone()
            doneIndex = indexPath
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
