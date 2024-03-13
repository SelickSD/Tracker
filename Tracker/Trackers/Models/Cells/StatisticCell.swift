//
//  StatisticCell.swift
//  Tracker
//
//  Created by Сергей Денисенко on 13.03.2024.
//

import UIKit

final class StatisticCell: UITableViewCell {
    static let identifier = "StatisticCell"

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "0"
        return label
    }()

    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        return view
    }()

    private lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.clipsToBounds = true
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInformation(name: String, count: Int) {
        informationLabel.text = name
        countLabel.text = String(count)
    }

    private func gradientColor(yourView:UIView, colorAngle: CGFloat){

        guard let firstColor = UIColor(hex: "#007BFA"),
              let secondColor = UIColor(hex: "##46E69D"),
              let thirdColor = UIColor(hex: "##FD4C49") else {return}

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [thirdColor.cgColor, secondColor.cgColor, firstColor.cgColor]
        gradientLayer.locations = [0.0, 0.5]

        let (start, end) = gradientPointsForAngle(colorAngle)
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        gradientLayer.frame = yourView.bounds
        gradientLayer.masksToBounds = true

        yourView.layer.insertSublayer(gradientLayer, at: 1)
        yourView.layer.masksToBounds = true
    }

    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {

        let end = pointForAngle(angle)
        let start = oppositePoint(end)
        let p0 = transformToGradientSpace(start)
        let p1 = transformToGradientSpace(end)
        return (p0, p1)
    }

    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
        let radians = angle * .pi / 180.0
        var x = cos(radians)
        var y = sin(radians)

        if (abs(x) > abs(y)) {
            x = x > 0 ? 1 : -1
            y = x * tan(radians)
        } else {
            y = y > 0 ? 1 : -1
            x = y / tan(radians)
        }
        return CGPoint(x: x, y: y)
    }

    private func oppositePoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: -point.x, y: -point.y)
    }

    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
    }

    override func draw(_ rect: CGRect) {
        gradientColor(yourView:gradientView, colorAngle: 1)
        drawSelf()
    }

    private func drawSelf() {
        self.addSubview(cardView)
        cardView.addSubview(countLabel)
        cardView.addSubview(informationLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 1),
            cardView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 1),
            cardView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -1),
            cardView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -1),

            countLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),

            informationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            informationLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant:  -12)
        ])
    }

    private func setupView() {
        self.addSubview(gradientView)

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            gradientView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            gradientView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}
