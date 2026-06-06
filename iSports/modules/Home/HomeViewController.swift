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

   
    private let bannerURLs: [String] = [
        "https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=800&q=80",
        "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80",
        "https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800&q=80"
    ]

    private let sportImageURLs: [String: String] = [
        "football":   "https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=400&q=80",
        "basketball": "https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&q=80",
        "tennis":     "https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400&q=80",
        "cricket":    "https://images.unsplash.com/photo-1624880357913-a8539238245b?w=400&q=80"
    ]

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
        startBannerAutoScroll()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerTimer?.invalidate()
        bannerTimer = nil
    }

    // MARK: - Banner Setup

    private func setupBanner() {
        guard let banner = bannerImageView else { return }
        banner.contentMode = .scaleAspectFill
        banner.clipsToBounds = true
        banner.layer.cornerRadius = 16
        
        banner.image = UIImage(named: "placeholder")

        guard !bannerURLs.isEmpty else { return }

        loadImage(from: bannerURLs[0]) { [weak self] image in
            guard let self = self, let image = image else { return }
            
            UIView.transition(with: banner,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                  banner.image = image
                              },
                              completion: nil)
        }
    }

    private func startBannerAutoScroll() {
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            self?.advanceBanner()
        }
    }

    private func advanceBanner() {
        guard let banner = bannerImageView else { return }
        currentBannerIndex = (currentBannerIndex + 1) % bannerURLs.count

        loadImage(from: bannerURLs[currentBannerIndex]) { [weak self] image in
            guard let self = self, let image = image else { return }

            // Slide-in animation: translate new image from right, fade old out
            let nextImageView = UIImageView(frame: banner.bounds)
            nextImageView.contentMode = .scaleAspectFill
            nextImageView.clipsToBounds = true
            nextImageView.image = image
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
                banner.image = nil
            } completion: { _ in
                banner.image = image
                nextImageView.removeFromSuperview()
            }
        }
    }

    // MARK: - Sport Card Images

    private func loadSportCardImages() {
        let pairs: [(UIImageView?, String)] = [
            (footballBgImageView,   sportImageURLs["football"]!),
            (basketballBgImageView, sportImageURLs["basketball"]!),
            (tennisBgImageView,     sportImageURLs["tennis"]!),
            (cricketBgImageView,    sportImageURLs["cricket"]!)
        ]

        for (imageView, urlString) in pairs {
            guard let iv = imageView else { continue }
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            loadImage(from: urlString) { image in
                guard let image = image else { return }
                UIView.transition(with: iv,
                                  duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: { iv.image = image },
                                  completion: nil)
            }
        }
    }

    // MARK: - Image Loading Helper

    /// Downloads an image from `urlString`, caches it in `URLCache`, and calls `completion` on the main queue.
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        // Return cached response immediately if available
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
        view.isUserInteractionEnabled = true // ضروري جداً
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tap)
    }

    @objc private func footballTapped() {
        animateTap(footballBgImageView)
        print("Football tapped!")
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as! LeagueDetailsViewController;
        
        vc.sportName = "football"
        vc.leagueId = 152
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func basketballTapped() {
        animateTap(basketballBgImageView)
        print("Basketball tapped!")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as! LeagueDetailsViewController;
         
         vc.sportName = "basketball"
         vc.leagueId = 766
         self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func tennisTapped() {
        animateTap(tennisBgImageView)
        //navigate to tennis screen
        print("Tennis tapped!")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as! LeagueDetailsViewController;
         
         vc.sportName = "tennis"
         vc.leagueId = 3866
         self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func cricketTapped() {
        animateTap(cricketBgImageView)
        print("Cricket tapped!")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as! LeagueDetailsViewController;
         
         vc.sportName = "cricket"
         vc.leagueId = 733
         self.navigationController?.pushViewController(vc, animated: true)
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
