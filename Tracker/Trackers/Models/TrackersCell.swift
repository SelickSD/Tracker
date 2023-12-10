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
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var emojiBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .blue
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
        view.backgroundColor = .blue
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

        self.addSubview(colorView)
        colorView.addSubview(emojiBackView)
        emojiBackView.addSubview(emojiView)
        self.addSubview(whiteView)
        whiteView.addSubview(plusButtonBackView)
        plusButtonBackView.addSubview(plusButton)


        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: self.centerYAnchor),

            whiteView.topAnchor.constraint(equalTo: self.centerYAnchor),
            whiteView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            whiteView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            emojiBackView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10),
            emojiBackView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            emojiBackView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackView.widthAnchor.constraint(equalToConstant: 24),

            emojiView.centerYAnchor.constraint(equalTo: emojiBackView.centerYAnchor),
            emojiView.centerXAnchor.constraint(equalTo: emojiBackView.centerXAnchor),
            emojiView.heightAnchor.constraint(equalToConstant: 20),
            emojiView.widthAnchor.constraint(equalToConstant: 20),

            plusButtonBackView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -20),
            plusButtonBackView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -10),
            plusButtonBackView.heightAnchor.constraint(equalToConstant: 34),
            plusButtonBackView.widthAnchor.constraint(equalToConstant: 34),

            plusButton.centerXAnchor.constraint(equalTo: plusButtonBackView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: plusButtonBackView.centerYAnchor)
        ])
    }
}
