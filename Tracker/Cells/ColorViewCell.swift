//
//  ColorViewCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 21.01.2024.
//
import UIKit
final class ColorViewCell: UICollectionViewCell {
    static let identifier = "ColorViewCell"

    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 3
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setColorOn(color: String) {
        contentView.backgroundColor = UIColor(hex: color)?.withAlphaComponent(0.3)
        colorView.layer.borderColor = UIColor.white.cgColor
        colorView.backgroundColor = UIColor(hex: color)
    }

    func setColorOff(color: String) {
        guard let color = UIColor(hex: color) else {return}
        contentView.backgroundColor = .ypWhite
        colorView.layer.borderColor = color.cgColor
        colorView.backgroundColor = color
    }

    private func setupView() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
}
