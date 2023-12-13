//
//  CreateNewHabitViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.12.2023.
//

import UIKit

class CreateNewHabitViewController: UIViewController {

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Новая привычка"
        return label
    }()

    private lazy var habitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.placeholder = "Введите название трекера"
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textAlignment = NSTextAlignment.left
        textField.layer.cornerRadius = 16
        textField.indent(size: 8)
        textField.delegate = self
        return textField
    }()

    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {

        view.backgroundColor = .ypWhite
        view.addSubview(pageNameLabel)
        view.addSubview(habitTextField)
        view.addSubview(mainTableView)

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            habitTextField.topAnchor.constraint(equalTo: pageNameLabel.bottomAnchor, constant: 40),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habitTextField.heightAnchor.constraint(equalToConstant: 75),

            mainTableView.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 40),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configCell(for cell: MainTableViewCell, with indexPath: IndexPath) {
//        guard let presenter = self.presenter else {return}
//
//        presenter.getCell(cell: cell, index: indexPath.row)
//        cell.delegate = self
//        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: -UITextFieldDelegate
extension CreateNewHabitViewController: UITextFieldDelegate {

}

//MARK: -UITableViewDelegate
extension CreateNewHabitViewController: UITableViewDelegate {

}

//MARK: -UITableViewDataSource
extension CreateNewHabitViewController: UITableViewDataSource {
    private var maxRows: Int { return 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }

        cell.configCell(rowOfCell: indexPath.row, maxCount: maxRows)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
