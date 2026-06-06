import UIKit

class UpcomingEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    
    private let primaryTeal = UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
    }
    
    private func setupImageViews() {
        // Make team images circular
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = 30
            iv.layer.masksToBounds = true
            iv.layer.borderWidth = 2
            iv.layer.borderColor = primaryTeal.withAlphaComponent(0.3).cgColor
            iv.backgroundColor = UIColor.systemGray6
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Re-enforce circle on layout
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = iv.bounds.width / 2
        }
    }
    
    func configure(with event: Event) {
        homeTeamNameLabel.text = event.displayHomeName
        awayTeamNameLabel.text = event.displayAwayName
        dateLabel.text = event.displayDate
        timeLabel.text = event.eventTime
        
        // Load team images from URL with placeholder
        let placeholder = UIImage(systemName: "shield.lefthalf.filled")
        ImageLoader.shared.loadImage(from: event.displayHomeLogo, into: homeTeamImageView, placeholder: placeholder)
        ImageLoader.shared.loadImage(from: event.displayAwayLogo, into: awayTeamImageView, placeholder: placeholder)
    }
    
    // Interactive touch feedback
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatePress(pressed: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatePress(pressed: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatePress(pressed: false)
    }
    
    private func animatePress(pressed: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.transform = pressed ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
            self.alpha = pressed ? 0.9 : 1.0
        }
    }
}
