//
//  UITableViewCell + Extention.swift
//  Tracker
//
//  Created by Сергей Денисенко on 02.02.2024.
//
import UIKit
extension UITableViewCell {
    func setSeparatorView() {
        let separatorView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            view.backgroundColor = .lightGray.withAlphaComponent(0.5)
            return view
        }()

        self.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
