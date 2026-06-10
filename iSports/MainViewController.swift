//
//  ViewController.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 01/06/2026.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigateToHome()
        }
    }
    
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            tabBarVC.addSettingsTab()

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarVC
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            } else {
                tabBarVC.modalPresentationStyle = .fullScreen
                self.present(tabBarVC, animated: true)
            }
        }
    }

}
