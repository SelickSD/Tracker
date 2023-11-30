//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 30.11.2023.
//

import UIKit

class TrackersViewController: UIViewController {

    private lazy var emptyView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "Star")
        return view
    }()

    private lazy var openingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Что будем отслеживать?"
        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()

    private lazy var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView(){
        view.backgroundColor = .ypWhite

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(addTapped))
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack

        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController

        view.addSubview(emptyView)
        view.addSubview(openingLabel)

        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            openingLabel.topAnchor.constraint(equalTo: emptyView.bottomAnchor),
            openingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func addTapped() {

    }
}
