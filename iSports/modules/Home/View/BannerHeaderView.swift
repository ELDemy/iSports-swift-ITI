import UIKit

class BannerHeaderView: UICollectionReusableView {
    static let identifier = "BannerHeaderView"
    
    private let bannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let bannerImages: [String] = ["banner1", "banner2", "banner3"]
    private var currentBannerIndex = 0
    private var bannerTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        startBannerAutoScroll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(bannerImageView)
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        bannerImageView.image = UIImage(named: bannerImages[0])
    }
    
    func startBannerAutoScroll() {
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { [weak self] _ in
            self?.advanceBanner()
        }
    }
    
    func stopBannerAutoScroll() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    private func advanceBanner() {
        let nextIndex = (currentBannerIndex + 1) % bannerImages.count
        guard let nextImage = UIImage(named: bannerImages[nextIndex]) else { return }
        
        currentBannerIndex = nextIndex
        
        let nextImageView = UIImageView(frame: bannerImageView.bounds)
        nextImageView.contentMode = .scaleAspectFill
        nextImageView.clipsToBounds = true
        nextImageView.layer.cornerRadius = 16
        nextImageView.image = nextImage
        nextImageView.alpha = 0
        nextImageView.transform = CGAffineTransform(translationX: bannerImageView.bounds.width * 0.3, y: 0)
        bannerImageView.addSubview(nextImageView)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.3, options: .curveEaseOut) {
            nextImageView.alpha = 1
            nextImageView.transform = .identity
        } completion: { _ in
            self.bannerImageView.image = nextImage
            nextImageView.removeFromSuperview()
        }
    }
}
