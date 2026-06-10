import UIKit
import SkeletonView

class UpcomingEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var cardBackgroundView: UIView!
    
    private let accentColor = UIColor(named: "accentColor") ?? UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViews()
        setupSkeletonable()
    }
    
    private func setupSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        cardBackgroundView?.isSkeletonable = true
        homeTeamImageView?.isSkeletonable = true
        awayTeamImageView?.isSkeletonable = true
        homeTeamNameLabel?.isSkeletonable = true
        awayTeamNameLabel?.isSkeletonable = true
        dateLabel?.isSkeletonable = true
        timeLabel?.isSkeletonable = true
        vsLabel?.isSkeletonable = true
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
        homeTeamNameLabel.text = event.displayHomeName
        awayTeamNameLabel.text = event.displayAwayName
        dateLabel.text = event.displayDate
        timeLabel.text = event.eventTime
        
        let placeholder = UIImage(systemName: "shield.lefthalf.filled")
        ImageLoader.shared.loadImage(from: event.displayHomeLogo, into: homeTeamImageView, placeholder: placeholder)
        ImageLoader.shared.loadImage(from: event.displayAwayLogo, into: awayTeamImageView, placeholder: placeholder)
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
            self.transform = pressed ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
            self.alpha = pressed ? 0.9 : 1.0
        }
    }
}
