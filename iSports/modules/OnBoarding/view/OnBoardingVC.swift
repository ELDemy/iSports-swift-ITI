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

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPage = 0

        setupPages()
        setupPageViewController()
    }

    private func setupPages() {

        pages = onboardingData.enumerated().map { index, item in

            let vc = UIStoryboard(
                name: "Main",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "OnBoardingPageVC"
            ) as! OnBoardingPageVC

            vc.model = item
            vc.isLastPage = index == onboardingData.count - 1
            vc.delegate = self

            return vc
        }
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

    func nextPage() {
        guard let currentVC = pageViewController.viewControllers?.first as? OnBoardingPageVC,
              let currentIndex = pages.firstIndex(of: currentVC)
        else { return }

        let nextIndex = currentIndex + 1

        if nextIndex < pages.count {
            pageViewController.setViewControllers(
                [pages[nextIndex]],
                direction: .forward,
                animated: true
            )
            pageControl.currentPage = nextIndex
        } else {
            // Triggered when "Get Started" is pressed on the last page
            navigateToMainScreen()
        }
    }

    func skipOnboarding() {
       
        navigateToMainScreen()
    }
    
    private func navigateToMainScreen() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainViewController")
        mainVC.modalPresentationStyle = .fullScreen
        
        self.present(mainVC, animated: true, completion: nil)
    }
}
