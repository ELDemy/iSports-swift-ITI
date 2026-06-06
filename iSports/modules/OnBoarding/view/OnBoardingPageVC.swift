//
//  OnBoardingPageVC.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import UIKit
protocol OnBoardingPageDelegate: AnyObject {
    func nextPage(from index: Int)
    func skipOnboarding()
}
class OnBoardingPageVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
 
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var skipButton: UIButton!
    
    
    @IBOutlet weak var actionButton: UIButton!
    var model: OnBoardingModel?
    var isLastPage = false
    var pageIndex: Int = 0
    weak var delegate: OnBoardingPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: model?.image ?? "")
        titleLabel.text = model?.title
        descLabel.text = model?.desc

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        skipButton.isHidden = isLastPage

        actionButton.setTitle(
            isLastPage ? "Get Started" : "Next",
            for: .normal
        )
        
        setupStyling()
    }
    
    private func setupStyling() {
        titleLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        titleLabel.textColor = UIColor(named: "accentColor") ?? .systemGreen
        
        descLabel.font = .systemFont(ofSize: 16, weight: .medium)
       // descLabel.textColor = .darkGray
        descLabel.textColor = UIColor(named: "descColor")
        
        actionButton.backgroundColor = UIColor(named: "accentColor") ?? .systemGreen
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.layer.cornerRadius = 12
        actionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        skipButton.setTitleColor(UIColor(named: "accentColor") ?? .systemGreen, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        descLabel.alpha = 0
        descLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.titleLabel.alpha = 1
                self.titleLabel.transform = .identity
                self.descLabel.alpha = 1
                self.descLabel.transform = .identity
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.9, delay: 0.39, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.titleLabel.alpha = 1
                self.titleLabel.transform = .identity
                self.descLabel.alpha = 1
                self.descLabel.transform = .identity
            }, completion: nil)
        }
    }
 
    @IBAction func nextTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.actionButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.actionButton.transform = .identity
            } completion: { _ in
                self.delegate?.nextPage(from: self.pageIndex)
            }
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.skipButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.skipButton.transform = .identity
            } completion: { _ in
                self.delegate?.skipOnboarding()
            }
        }
    }
}
