//
//  TrackersCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 10.12.2023.
//

import UIKit

final class TrackersCell: UICollectionViewCell {
    static let identifier = "TrackersCell"
    weak var delegate: TrackersCellDelegate?
    private var isCompleted: Bool = false
    private var id: UUID = UUID()
    private var currentDays: [DayOfWeek] = []
    private var count = 0
    
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
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.alpha = 1
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var plusButtonBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 17
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "0 дней"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor = .ypWhite
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func configCell(track: Tracker, isCompleted: Bool, count: Int, isEnabled: Bool) {
        
        plusButtonBackView.backgroundColor = track.color
        plusButton.isEnabled = isEnabled
        colorView.backgroundColor = track.color
        emojiBackView.backgroundColor = .white.withAlphaComponent(0.3)
        emojiLabel.text = track.emoji
        descriptionLabel.text = track.name
        currentDays = track.schedule
        id = track.id
        self.isCompleted = isCompleted
        dateLabel.text = count.days()
        self.count = count
        checkStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlusButton() {
        if !isCompleted {
            delegate?.didTapPlusButton(id: id)
            isCompleted = true
            checkStatus()
            count += 1
            dateLabel.text = count.days()
        } else {
            delegate?.didUnTapPlusButton(id: id)
            isCompleted = false
            checkStatus()
            count -= 1
            dateLabel.text = count.days()
        }
    }
    
    private func checkStatus() {
        if isCompleted {
            plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
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
        emojiBackView.addSubview(emojiLabel)
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
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackView.centerXAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -10),
            descriptionLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -10)
        ])
    }
}
