//
//  OnBoardingPageVC.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import UIKit
protocol OnBoardingPageDelegate: AnyObject {
    func nextPage()
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
        imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
       
        }
 
    @IBAction func nextTapped(_ sender: Any) {
        delegate?.nextPage()
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        delegate?.skipOnboarding()
    }
}
