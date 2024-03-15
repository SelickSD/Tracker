//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 11.12.2023.
//
import UIKit
final class CreateNewTrackerViewController: UIViewController,
                                            CreateNewHabitViewControllerDelegate {

    weak var delegate: TrackersViewControllerDelegate?
    private var isReady = false

    private lazy var pageNameLabel: UILabel = {
        let pageName = NSLocalizedString("createNewTrackerView.pageName", 
                                         comment: "Text displayed like page name")
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = pageName
        return label
    }()

    private lazy var createHabitButton: UIButton = {
        let createHabitButtonName = NSLocalizedString("createNewTrackerView.createHabitButtonName", 
                                                      comment: "Text displayed like name of create habit button")
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle(createHabitButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateHabitButton), for: .touchUpInside)
        return button
    }()

    private lazy var createEventButton: UIButton = {
        let createEventButtonName = NSLocalizedString("createNewTrackerView.createEventButtonName", 
                                                      comment: "Text displayed like name of create event button")
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.tintColor = .ypWhite
        button.setTitle(createEventButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapCreateEventButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func fetchNewTrack(newHabit: TrackerCategory) {
        delegate?.fetchNewTrack(newHabit: newHabit)
    }

    @objc private func didTapCreateHabitButton() {
        let newHabitViewController = CreateNewHabitViewController()
        newHabitViewController.delegate = self
        self.present(newHabitViewController, animated: true)
    }

    @objc private func didTapCreateEventButton() {
        let newHabitViewController = CreateNewHabitViewController()
        newHabitViewController.delegate = self
        newHabitViewController.isEvent = true
        self.present(newHabitViewController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        [pageNameLabel, createHabitButton, createEventButton].forEach{
            $0.clipsToBounds = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
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
