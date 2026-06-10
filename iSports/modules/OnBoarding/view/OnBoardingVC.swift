//
//  OnBoardingVC.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import UIKit

class OnBoardingVC: UIViewController {



    @IBOutlet weak var pageControl: UIPageControl!
    private var pageViewController: UIPageViewController!

    private var pages: [OnBoardingPageVC] = []
    private var presenter: OnBoardingPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = OnBoardingPresenter(view: self)
        presenter.viewDidLoad()
    }

    private func setupPageViewController() {

        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )

        addChild(pageViewController)
        view.insertSubview(pageViewController.view, at: 0)

        pageViewController.view.frame = view.bounds

        pageViewController.setViewControllers(
            [pages[0]],
            direction: .forward,
            animated: true
        )

        pageViewController.dataSource = self
        pageViewController.delegate = self

        pageViewController.didMove(toParent: self)
    }
}

extension OnBoardingVC: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {

        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? OnBoardingPageVC,
              let index = pages.firstIndex(where: { $0 === currentVC })
        else { return }

        pageControl.currentPage = index
    }
}
extension OnBoardingVC: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let index = pages.firstIndex(
            of: viewController as! OnBoardingPageVC
        ) else { return nil }

        if index == 0 { return nil }

        return pages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let index = pages.firstIndex(
            of: viewController as! OnBoardingPageVC
        ) else { return nil }

        if index == pages.count - 1 { return nil }

        return pages[index + 1]
    }
}


extension OnBoardingVC: OnBoardingPageDelegate {

    func nextPage(from index: Int) {
        presenter.didTapNext(from: index)
    }

    func skipOnboarding() {
        presenter.didTapSkip()
    }
    
    
}

extension OnBoardingVC: OnBoardingViewProtocol {
    func setupPages(count: Int) {
        pageControl.numberOfPages = count
        pageControl.currentPage = 0
        
        pages = (0..<count).map { index in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingPageVC") as! OnBoardingPageVC
            vc.model = presenter.modelForPage(at: index)
            vc.isLastPage = index == count - 1
            vc.pageIndex = index
            vc.delegate = self
            return vc
        }
        
        setupPageViewController()
    }
    
    func navigateToPage(at index: Int) {
        pageViewController.setViewControllers([pages[index]], direction: .forward, animated: true)
        pageControl.currentPage = index
    }
    
    func navigateToMainScreen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            print("Error: Could not find MainTabBarController in Storyboard")
            return
        }
        tabBarVC.addSettingsTab()

        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .reveal
        transition.subtype = .fromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)

        navigationController?.setViewControllers([tabBarVC], animated: false)
    }
}
