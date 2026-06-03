//
//  HomeViewController.swift
//  iSports
//
//  Created by JETSMobileLabMini7 on 02/06/2026.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Outlets

    /// Banner imageView (id: FHx-BR-3fk in storyboard)
    @IBOutlet private weak var bannerImageView: UIImageView!

    /// Sport card background imageViews
    @IBOutlet private weak var footballBgImageView: UIImageView!
    @IBOutlet private weak var basketballBgImageView: UIImageView!
    @IBOutlet private weak var tennisBgImageView: UIImageView!
    @IBOutlet private weak var cricketBgImageView: UIImageView!

    // MARK: - Unsplash image URLs
    // Using Unsplash Source API — free, no key required, returns a redirect to a photo.
    // Each URL targets a fixed photo ID for reproducible results.

    private let bannerURLs: [String] = [
        // Stadium crowd cheering at night
        "https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=800&q=80",
        // Soccer match aerial view
        "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800&q=80",
        // Basketball arena lights
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
        banner.backgroundColor = UIColor(red: 0.20, green: 0.68, blue: 0.90, alpha: 1)

        // Load first banner image
        loadImage(from: bannerURLs[0]) { [weak self] image in
            guard let self = self, let image = image else { return }
            UIView.transition(with: banner,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: { banner.image = image },
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

            UIView.animate(withDuration: 0.6,
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
}
