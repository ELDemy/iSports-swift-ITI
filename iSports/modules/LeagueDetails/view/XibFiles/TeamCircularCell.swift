import UIKit
import SkeletonView

class TeamCircularCell: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    private let accentColor = UIColor(named: "accentColor") ?? UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeletonable()
    }
    
    private func setupSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        teamImageView?.isSkeletonable = true
        teamNameLabel?.isSkeletonable = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let iv = teamImageView else { return }
        iv.layer.cornerRadius  = iv.bounds.width / 2
        iv.layer.masksToBounds = true
        iv.layer.borderWidth   = 2
        iv.layer.borderColor   = accentColor.withAlphaComponent(0.35).cgColor
        iv.backgroundColor     = UIColor(named: "CardBackground") ?? .systemGray6
        iv.skeletonCornerRadius = Float(iv.bounds.width / 2)
    }
    
    func configure(with team: Team) {
        let placeholder = UIImage(systemName: "person.crop.circle.fill")
        if let iv = teamImageView {
            ImageLoader.shared.loadImage(from: team.teamLogo, into: iv, placeholder: placeholder)
        }
        teamNameLabel?.text = team.teamName
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
            self.transform = pressed ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        }
    }
}
