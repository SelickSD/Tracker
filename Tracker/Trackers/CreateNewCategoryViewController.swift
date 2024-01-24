//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 24.01.2024.
//

import UIKit

class CreateNewCategoryViewController: UIViewController {

    weak var delegate: CreateNewCategoryViewControllerDelegate?
    private var newCategoryName: String?

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Новая категория"
        return label
    }()

    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.placeholder = "Введите название категории"
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textAlignment = NSTextAlignment.left
        textField.layer.cornerRadius = 16
        textField.indent(size: 8)
        textField.delegate = self
        textField.addTarget(self, action: #selector(categoryTextChanged), for: .editingChanged)
        return textField
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupGestures()
    }

    @objc private func didTapCreateButton() {
        guard let categoryName = newCategoryName else {return}
        delegate?.fetchCategoryName(name: categoryName)
        self.dismiss(animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func categoryTextChanged(_ textField: UITextField) {
        newCategoryName = textField.text
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }

    private func setupView() {
        view.backgroundColor = .ypWhite

        view.addSubview(pageNameLabel)
        view.addSubview(categoryTextField)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            categoryTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 102),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),

            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}

//MARK: -UITextFieldDelegate
extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
