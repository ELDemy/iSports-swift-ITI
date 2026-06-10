//
//  SplashViewController.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 01/06/2026.
//

import Lottie
import UIKit

class SplashViewController: UIViewController {
    

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .main
        setupAnimation()
    }

    private func setupAnimation() {
        animationView = LottieAnimationView(name: "SplashAnimation")

        guard let animationView = animationView else { return }

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        
        view.addSubview(animationView)

        animationView.play { [weak self] (finished) in
            if finished {
                let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
                if hasSeenOnboarding {
                    self?.transitionToMainScreen()
                } else {
                    self?.transitionToOnboardingScreen()
                }
            }
        }
    }
    private func transitionToOnboardingScreen() {
        let onboardingVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "OnBoardingVC")

        navigationController?.setViewControllers([onboardingVC], animated: true)
    }
    private func transitionToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else {
            return
        }
        navigationController?.setViewControllers([tabBarVC], animated: true)
    }
}

