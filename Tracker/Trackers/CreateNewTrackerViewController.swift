//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.12.2023.
//

import UIKit

final class CreateNewTrackerViewController: UIViewController,
                                            CreateNewHabitViewControllerDelegate {

    var categories: [String] = []
    weak var delegate: TrackersViewControllerDelegate?

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateEventButton), for: .touchUpInside)
        return button
    }()

    private var isReady = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func fetchHabit(newHabit: TrackerCategory) {
        var isNewName = true
        delegate?.fetchNewTrack(newHabit: newHabit)

        for item in categories {
            if item == newHabit.name {
                isNewName = false
            }
        }

        if isNewName {
            categories.append(newHabit.name)
        }
    }

    @objc private func didTapCreateHabitButton() {
        let newHabitViewController = CreateNewHabitViewController()
        newHabitViewController.delegate = self
        newHabitViewController.categories = categories
        self.present(newHabitViewController, animated: true)
    }

    @objc private func didTapCreateEventButton() {
        let newHabitViewController = CreateNewHabitViewController()
        newHabitViewController.delegate = self
        newHabitViewController.categories = categories
        newHabitViewController.isEvent = true
        self.present(newHabitViewController, animated: true)
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
