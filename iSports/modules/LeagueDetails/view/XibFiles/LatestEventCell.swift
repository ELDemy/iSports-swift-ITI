import UIKit
import SkeletonView

class LatestEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    
    private let accentColor = UIColor(resource: .accent)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
        setupSkeletonable()
    }
    
    private func setupSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        homeTeamNameLabel?.isSkeletonable = true
        awayTeamNameLabel?.isSkeletonable = true
        scoreLabel?.isSkeletonable = true
        dateLabel?.isSkeletonable = true
        timeLabel?.isSkeletonable = true
        homeTeamImageView?.isSkeletonable = true
        awayTeamImageView?.isSkeletonable = true
    }
    
    private func setupImageViews() {
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.backgroundColor = UIColor(named: "CardBackground")?.withAlphaComponent(0.4) ?? UIColor.systemGray6
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for imageView in [homeTeamImageView, awayTeamImageView] {
            guard let iv = imageView else { continue }
            iv.layer.cornerRadius = iv.bounds.width / 2
            iv.skeletonCornerRadius = Float(iv.bounds.width / 2)
        }
    }
    
    func configure(with event: Event) {
        homeTeamNameLabel?.text = event.displayHomeName
        awayTeamNameLabel?.text = event.displayAwayName
        scoreLabel?.text = " \(event.eventFinalResult ?? "VS") "
        dateLabel?.text = event.eventDate
        timeLabel?.text = event.eventTime
        
        let placeholder = UIImage(resource:.logoWithBackgorund)
        if let homeIV = homeTeamImageView {
            ImageLoader.shared.loadImage(from: event.homeTeamLogo, into: homeIV, placeholder: placeholder)
        }
        if let awayIV = awayTeamImageView {
            ImageLoader.shared.loadImage(from: event.awayTeamLogo, into: awayIV, placeholder: placeholder)
        }
    }
    
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
