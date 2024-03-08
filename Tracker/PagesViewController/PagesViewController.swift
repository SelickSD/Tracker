//
//  PagesViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//

import UIKit

final class PagesViewController: UIViewController {

    weak var delegate: OnboardingViewDelegate?

    private lazy var pagesManeView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private lazy var openingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        return label
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hex: "#1A1B22")
        button.layer.cornerRadius = 16
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = UIColor.init(hex: "#1A1B22")
        pageControl.pageIndicatorTintColor = UIColor.init(hex: "#1A1B22")?.withAlphaComponent(0.3)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSelf()
    }

    func setupView(settings: PagesSettings) {
        pagesManeView.image = settings.image
        openingLabel.text = settings.label
    }

    func setPages(currentIndex: Int) {
        pageControl.currentPage = currentIndex
    }

    @objc private func didTapCancelButton() {
        delegate?.dismissOnboardingView()
    }

    private func setupSelf() {
        view.addSubview(pagesManeView)
        view.addSubview(cancelButton)
        pagesManeView.addSubview(pageControl)
        pagesManeView.addSubview(openingLabel)

        NSLayoutConstraint.activate([
            pagesManeView.topAnchor.constraint(equalTo: view.topAnchor),
            pagesManeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagesManeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagesManeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            openingLabel.centerYAnchor.constraint(equalTo: pagesManeView.centerYAnchor),
            openingLabel.leadingAnchor.constraint(equalTo: pagesManeView.leadingAnchor, constant: 16),
            openingLabel.trailingAnchor.constraint(equalTo: pagesManeView.trailingAnchor, constant: -16),

            pageControl.centerXAnchor.constraint(equalTo: pagesManeView.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: openingLabel.topAnchor, constant: 206),

            cancelButton.leadingAnchor.constraint(equalTo: pagesManeView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: pagesManeView.trailingAnchor, constant: -20),
            cancelButton.centerXAnchor.constraint(equalTo: pagesManeView.centerXAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: openingLabel.topAnchor, constant: 236)
        ])
    }
}
