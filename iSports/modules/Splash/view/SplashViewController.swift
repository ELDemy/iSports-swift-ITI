//
//  SplashViewController.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 01/06/2026.
//

import Lottie
import UIKit

class SplashViewController: UIViewController {
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .accent
        setupAnimation()
    }

    private func setupAnimation() {
        animationView = LottieAnimationView(name: "SplashAnimation")

        guard let animationView = animationView else { return }

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        view.addSubview(animationView)

        animationView.play { [weak self] (finished) in
            if finished {
              //  self?.transitionToMainScreen()
                self?.transitionToOnboardingScreen()
            }
        }
    }
    private func transitionToOnboardingScreen() {
        let onboardingVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "OnBoardingVC")

        onboardingVC.modalPresentationStyle = .fullScreen
        self.present(onboardingVC, animated: true, completion: nil)
    }

    private func transitionToMainScreen() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainTabBarController")

        navigationController?.setViewControllers([homeVC], animated: true)
    }
    


}

