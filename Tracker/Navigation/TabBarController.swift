//
//  TabBarController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 30.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
        setupTabBarController()
    }

    private func setupTabBarController() {
        let items: [TabBarItem] = [.trackers, .statistic]
        self.viewControllers = items.map({tabBarItem in
            switch tabBarItem {
            case .trackers:
                return createNavigationController(for: TrackersViewController(), index: .trackers)
            case .statistic:
                return createNavigationController(for: StatisticViewController(), index: .statistic)
            }
        })
    }

    private func createNavigationController(for rootViewController: UIViewController,
                                            index: TabBarItem) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = index.label
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem.title = index.label
        navigationController.tabBarItem.image = index.image
        return navigationController
    }
}

// MARK: - TabBarItem
extension TabBarController {
    private enum TabBarItem {
        case trackers
        case statistic

        var label: String {
            switch self {
            case .trackers:
                return "Трекеры"
            case .statistic:
                return "Статистика"
            }
        }

        var image: UIImage? {
            switch self {
            case .trackers:
                return UIImage(named: "Trackers")
            case .statistic:
                return UIImage(named: "Statistic")
            }
        }
    }
}
