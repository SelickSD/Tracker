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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {

        view.backgroundColor = .ypWhite
        view.addSubview(pageNameLabel)

        NSLayoutConstraint.activate([
            pageNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
}
