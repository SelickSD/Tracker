//
//  TrackersCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 10.12.2023.
//

import UIKit

class TrackersCell: UICollectionViewCell {
    static let identifier = "TrackersCell"

    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .green
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var whiteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var emojiBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .green
        view.alpha = 1
        return view
    }()

    private lazy var emojiView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "star")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .cyan
        return view
    }()

    private lazy var plusButtonBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 17
        view.clipsToBounds = true
        view.backgroundColor = .green
        return view
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .ypWhite
        return button
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "4 дня"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Поливать растения"
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupView() {

        self.layer.cornerRadius = 12
        self.clipsToBounds = true

        self.addSubview(whiteView)
        whiteView.addSubview(plusButtonBackView)
        plusButtonBackView.addSubview(plusButton)
        whiteView.addSubview(dateLabel)

        self.addSubview(colorView)
        colorView.addSubview(emojiBackView)
        emojiBackView.addSubview(emojiView)
        colorView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([

            plusButtonBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            plusButtonBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            plusButtonBackView.heightAnchor.constraint(equalToConstant: 34),
            plusButtonBackView.widthAnchor.constraint(equalToConstant: 34),

            whiteView.topAnchor.constraint(equalTo: plusButtonBackView.topAnchor, constant: -10),
            whiteView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            plusButton.centerXAnchor.constraint(equalTo: plusButtonBackView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: plusButtonBackView.centerYAnchor),

            dateLabel.centerYAnchor.constraint(equalTo: plusButtonBackView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 10),

            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: whiteView.topAnchor),

            emojiBackView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10),
            emojiBackView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            emojiBackView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackView.widthAnchor.constraint(equalToConstant: 24),

            emojiView.centerYAnchor.constraint(equalTo: emojiBackView.centerYAnchor),
            emojiView.centerXAnchor.constraint(equalTo: emojiBackView.centerXAnchor),
            emojiView.heightAnchor.constraint(equalToConstant: 20),
            emojiView.widthAnchor.constraint(equalToConstant: 20),

            descriptionLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10)
        ])
    }
}
