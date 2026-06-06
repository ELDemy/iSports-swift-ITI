import UIKit

class LatestEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    
    private let primaryTeal = UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
    }
    
    private func setupImageViews() {
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = 20
            iv.layer.masksToBounds = true
            iv.layer.borderWidth = 1.5
            iv.layer.borderColor = primaryTeal.withAlphaComponent(0.2).cgColor
            iv.backgroundColor = UIColor.systemGray6
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = iv.bounds.width / 2
        }
    }
    
    func configure(with event: LatestEvent) {
        homeTeamNameLabel?.text = event.displayHomeName
        awayTeamNameLabel?.text = event.displayAwayName
        scoreLabel?.text = " \(event.displayResult ?? "VS") "
        dateLabel?.text = event.eventDate
        timeLabel?.text = event.eventTime
        
        // Load team images
        let placeholder = UIImage(systemName: "shield.lefthalf.filled")
        if let homeIV = homeTeamImageView {
            ImageLoader.shared.loadImage(from: event.homeTeamLogo, into: homeIV, placeholder: placeholder)
        }
        if let awayIV = awayTeamImageView {
            ImageLoader.shared.loadImage(from: event.awayTeamLogo, into: awayIV, placeholder: placeholder)
        }
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
            self.transform = pressed ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            self.alpha = pressed ? 0.9 : 1.0
        }
    }
}
