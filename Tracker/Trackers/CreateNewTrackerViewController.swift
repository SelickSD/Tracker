//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.12.2023.
//

import UIKit

class CreateNewTrackerViewController: UIViewController {

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Создание трекера"
        return label
    }()

    private lazy var createHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle("Привычка", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateHabitButton), for: .touchUpInside)
        return button
    }()

    private lazy var createEventButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle("Не регулярное событие", for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateEventButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @objc private func didTapCreateHabitButton() {
        self.present(CreateNewHabitViewController(), animated: true)
    }

    @objc private func didTapCreateEventButton() {

    }

    private func setupView() {

        view.backgroundColor = .ypWhite
        view.addSubview(pageNameLabel)
        view.addSubview(createHabitButton)
        view.addSubview(createEventButton)

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            createHabitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createHabitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            createEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createEventButton.heightAnchor.constraint(equalToConstant: 60),
            createEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createEventButton.topAnchor.constraint(equalTo: createHabitButton.bottomAnchor, constant: 16)
        ])
    }
}
