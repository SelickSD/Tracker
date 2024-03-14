//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Сергей Денисенко on 08.03.2024.
//

import UIKit

final class OnboardingViewController: UIPageViewController,
                                      UIPageViewControllerDataSource,
                                      UIPageViewControllerDelegate,
                                      OnboardingViewDelegate{

    lazy var pages: [UIViewController] = {
        let blue = PagesViewController()
        blue.delegate = self
        blue.setupView(settings: .blue)

        let red = PagesViewController()
        red.delegate = self
        red.setupView(settings: .red)

        return [blue, red]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let currentViewController = pageViewController.viewControllers?.first as? PagesViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            currentViewController.setPages(currentIndex: currentIndex)
        }
    }

    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return nil
        }

        return pages[nextIndex]
    }

    func dismissOnboardingView() {
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        self.removeFromParent()
        window?.rootViewController = TabBarController()
    }
}
