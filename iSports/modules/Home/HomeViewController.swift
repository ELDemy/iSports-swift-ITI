//
//  HomeViewController.swift
//  iSports
//
//  Created by JETSMobileLabMini7 on 02/06/2026.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var basketballView: UIView!
    @IBOutlet weak var footballView: UIView!
    
    @IBOutlet weak var cricketView: UIView!
    @IBOutlet weak var tennisView: UIView!
    @IBOutlet private weak var bannerImageView: UIImageView!

    @IBOutlet private weak var footballBgImageView: UIImageView!
    @IBOutlet private weak var basketballBgImageView: UIImageView!
    @IBOutlet private weak var tennisBgImageView: UIImageView!
    @IBOutlet private weak var cricketBgImageView: UIImageView!

   
    private let bannerImages: [String] = ["banner1", "banner2", "banner3"]

    

    // MARK: - Banner animation state
    private var currentBannerIndex = 0
    private var bannerTimer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        loadSportCardImages()
        gestures()
        
        
    }
    private func gestures(){
        setupTapGesture(for: footballView, action: #selector(footballTapped))
            setupTapGesture(for: basketballView, action: #selector(basketballTapped))
           setupTapGesture(for: tennisView, action: #selector(tennisTapped))
            setupTapGesture(for: cricketView, action: #selector(cricketTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the nav bar on the Home screen — it's shown again when pushing Leagues
        navigationController?.setNavigationBarHidden(true, animated: animated)
        startBannerAutoScroll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Restore the nav bar for any screen we push onto (Leagues, etc.)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        bannerTimer?.invalidate()
        bannerTimer = nil
    }

    // MARK: - Banner Setup

    private func setupBanner() {
        guard let banner = bannerImageView else { return }
            banner.contentMode = .scaleAspectFill
            banner.clipsToBounds = true
            banner.layer.cornerRadius = 16
            
            banner.image = UIImage(named: bannerImages[0])
    }

    private func startBannerAutoScroll() {
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            self?.advanceBanner()
        }
    }

    private func advanceBanner() {
        guard let banner = bannerImageView else { return }
        
        let nextIndex = (currentBannerIndex + 1) % bannerImages.count
        
        guard let nextImage = UIImage(named: bannerImages[nextIndex]) else {
            print("DEBUG: Image named \(bannerImages[nextIndex]) not found!")
            return
        }
        
        currentBannerIndex = nextIndex

        let nextImageView = UIImageView(frame: banner.bounds)
        nextImageView.contentMode = .scaleAspectFill
        nextImageView.clipsToBounds = true
        nextImageView.image = nextImage
        nextImageView.alpha = 0
        nextImageView.transform = CGAffineTransform(translationX: banner.bounds.width * 0.3, y: 0)
        banner.addSubview(nextImageView)

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.85,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseOut) {
            nextImageView.alpha = 1
            nextImageView.transform = .identity
        } completion: { _ in
            banner.image = nextImage
            nextImageView.removeFromSuperview()
        }
    }


    private func loadSportCardImages() {
        let pairs: [(UIImageView?, String)] = [
            (footballBgImageView, "football"),
            (basketballBgImageView, "basketball"),
            (tennisBgImageView, "tennis"),
            (cricketBgImageView, "cricket")
        ]

        for (imageView, imageName) in pairs {
            guard let iv = imageView else { continue }

            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true

            UIView.transition(
                with: iv,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: {
                    iv.image = UIImage(named: imageName)
                },
                completion: nil
            )
        }
    }


    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
        if let cached = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cached.data) {
            DispatchQueue.main.async { completion(image) }
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, _ in
            var image: UIImage?
            if let data = data, let resp = response {
                image = UIImage(data: data)
                let cachedResponse = CachedURLResponse(response: resp, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            }
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
    
    private func setupTapGesture(for view: UIView, action: Selector) {
        view.isUserInteractionEnabled = true 
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tap)
    }

    @objc private func footballTapped() {
        animateTap(footballBgImageView)
        navigateToLeagues(sport: "football")
    }

    @objc private func basketballTapped() {
        animateTap(basketballBgImageView)
        navigateToLeagues(sport: "basketball")
    }

    @objc private func tennisTapped() {
        animateTap(tennisBgImageView)
        navigateToLeagues(sport: "tennis")
    }

    @objc private func cricketTapped() {
        animateTap(cricketBgImageView)
        navigateToLeagues(sport: "cricket")
    }

    private func navigateToLeagues(sport: String) {
        guard let nav = self.navigationController,
              let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else { return }
        
        let router = AppRouter(navigationController: nav)
        vc.presenter = LeaguePresenter(view: vc, sportName: sport, router: router)
        nav.pushViewController(vc, animated: true)
    }
    
    private func animateTap(_ view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.alpha = 1.0
            }
        }
    }
}
