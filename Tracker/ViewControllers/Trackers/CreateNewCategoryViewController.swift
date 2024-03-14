//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 24.01.2024.
//

import UIKit

final class CreateNewCategoryViewController: UIViewController {

    weak var delegate: CreateNewCategoryViewControllerDelegate?
    private var newCategoryName: String?
    
    private lazy var pageNameLabel: UILabel = {
        let pageName = NSLocalizedString("createNewCategory.pageName", comment: "Text displayed like page name")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = pageName
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var categoryTextField: UITextField = {
        let categoryTextFieldPlaceholder = NSLocalizedString("createNewCategory.categoryTextField.placeholder", comment: "Text displayed like placeholder")
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.placeholder = categoryTextFieldPlaceholder
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.textAlignment = NSTextAlignment.left
        textField.layer.cornerRadius = 16
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.indent(size: 16)
        textField.delegate = self
        textField.addTarget(self, action: #selector(categoryTextChanged), for: .editingChanged)
        return textField
    }()

    private lazy var createButton: UIButton = {
        let doneButtonName = NSLocalizedString("createNewCategory.doneButtonName", comment: "Text displayed like name of Done button")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.setTitle(doneButtonName, for: .normal)
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
        if textField.hasText {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .lightGray
            createButton.isEnabled = false
        }
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
