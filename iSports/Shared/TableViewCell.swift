//
//  TableViewCell.swift
//  MAD46_Sports
//
//  Created by TaqieAllah on 30/04/2026.
//

import UIKit
import SDWebImage
import SkeletonView

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    @IBOutlet weak var labelTxt: UILabel!
    var onFavTapped: (() -> Void)?
    

    @IBOutlet weak var favBtn: UIButton!
    
    @IBAction func onFav(_ sender: Any) {
        onFavTapped?()
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                self.favBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                let scale = CGAffineTransform(scaleX: 1.4, y: 1.4)
                let rotate = CGAffineTransform(rotationAngle: 0.2)
                self.favBtn.transform = scale.concatenating(rotate)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
                let rotate = CGAffineTransform(rotationAngle: -0.2)
                self.favBtn.transform = scale.concatenating(rotate)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                self.favBtn.transform = .identity
            }
            
        }, completion: nil)
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            self.selectionStyle = .none
            self.contentView.backgroundColor = UIColor(named: "AppSurface") ?? .systemBackground
            self.backgroundColor = .clear
            
            self.imageV.skeletonCornerRadius = 32
            
            self.isSkeletonable = true
            self.contentView.isSkeletonable = true
            self.labelTxt.isSkeletonable = true
            self.imageV.isSkeletonable = true
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 6, left: 16, bottom: 4, right: 16)
        contentView.frame = contentView.frame.inset(by: margins)
        
        // Card shadow
        contentView.layer.cornerRadius = 14
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowRadius = 6
        contentView.layer.masksToBounds = false
        
        contentView.applySubtlePrimaryGradient(radius: 14)
        
        self.layoutIfNeeded()
        
        let size = min(imageV.bounds.width, imageV.bounds.height)
        imageV.layer.cornerRadius = size / 2
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFill
        
        imageV.layer.borderWidth = 1.5
        imageV.layer.borderColor = (UIColor(named: "AppPrimary") ?? .systemGreen).withAlphaComponent(0.3).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setup(_ league: LeagueModel, placeholder: UIImage?) {
        labelTxt.text = league.leagueName

        if let urlString = league.leagueLogo,
           let url = URL(string: urlString) {
           
            imageV.sd_setImage(with: url, placeholderImage: placeholder)

        } else {
            imageV.image = placeholder
        }
    }
    func updateFavIcon(isFav : Bool)
    {
        let image = isFav ? Constants.Icons.isFav : Constants.Icons.noFav
            favBtn.setImage(UIImage(systemName: image), for: .normal)
            favBtn.tintColor = .red
    }
}

