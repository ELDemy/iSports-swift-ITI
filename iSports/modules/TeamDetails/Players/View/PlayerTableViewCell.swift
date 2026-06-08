import UIKit
import SkeletonView

class PlayerTableViewCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.93, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let numberContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.85, green: 0.95, blue: 0.88, alpha: 1.0)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let playerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(red: 0.76, green: 0.58, blue: 0.22, alpha: 1.0)
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupSkeletonable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSkeletonable() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        containerView.isSkeletonable = true
        numberContainerView.isSkeletonable = true
        numberLabel.isSkeletonable = true
        playerImageView.isSkeletonable = true
        playerImageView.skeletonCornerRadius = 24
        infoStackView.isSkeletonable = true
        nameLabel.isSkeletonable = true
        positionLabel.isSkeletonable = true
        statsStackView.isSkeletonable = true
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        
        numberContainerView.addSubview(numberLabel)
        containerView.addSubview(numberContainerView)
        containerView.addSubview(playerImageView)
        
        infoStackView.addArrangedSubview(nameLabel)
        
        let positionStack = UIStackView()
        positionStack.axis = .horizontal
        positionStack.spacing = 8
        positionStack.alignment = .center
        positionStack.addArrangedSubview(positionLabel)
        
        infoStackView.addArrangedSubview(positionStack)
        infoStackView.addArrangedSubview(statsStackView)
        
        containerView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            numberContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            numberContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            numberContainerView.widthAnchor.constraint(equalToConstant: 30),
            numberContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            numberLabel.centerXAnchor.constraint(equalTo: numberContainerView.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: numberContainerView.centerYAnchor),
            
            playerImageView.leadingAnchor.constraint(equalTo: numberContainerView.trailingAnchor, constant: 12),
            playerImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playerImageView.widthAnchor.constraint(equalToConstant: 48),
            playerImageView.heightAnchor.constraint(equalToConstant: 48),
            
            infoStackView.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            infoStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            positionLabel.heightAnchor.constraint(equalToConstant: 20),
            positionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 34)
        ])
    }
    
    private func createStatView(icon: String, text: String, tintColor: UIColor = .systemGray) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        
        let imgView = UIImageView(image: UIImage(systemName: icon))
        imgView.tintColor = tintColor
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .darkGray
        
        stack.addArrangedSubview(imgView)
        stack.addArrangedSubview(lbl)
        
        return stack
    }
    
    func configure(with player: PlayerModel) {
        numberLabel.text = player.playerNumber ?? ""
        nameLabel.text = player.playerName ?? "Unknown"
        
        let position = player.playerType ?? ""
        var posText = ""
        switch position {
        case "Goalkeepers": posText = " GK "
        case "Defenders": posText = " DF "
        case "Midfielders": posText = " MF "
        case "Forwards": posText = " FW "
        default: posText = position.isEmpty ? " N/A " : " \(String(position.prefix(2)).uppercased()) "
        }
        positionLabel.text = posText
        
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let age = player.playerAge ?? "-"
        let rating = player.playerRating ?? "-"
        let matches = player.playerMatchPlayed ?? "-"
        let goals = (player.playerGoals == nil || player.playerGoals == "") ? "0" : player.playerGoals!
        
        statsStackView.addArrangedSubview(createStatView(icon: "person.text.rectangle", text: "\(age)y", tintColor: .systemBlue))
        if rating != "-" {
            statsStackView.addArrangedSubview(createStatView(icon: "star.fill", text: rating, tintColor: .systemYellow))
        }
        statsStackView.addArrangedSubview(createStatView(icon: "sportscourt.fill", text: matches, tintColor: .systemGreen))
        statsStackView.addArrangedSubview(createStatView(icon: "soccerball", text: goals, tintColor: .darkGray))
        
        let placeholder = if player.playerType == "Goalkeepers" {
            UIImage(named: "goalkeeper")
        } else {
            UIImage(named: "player")
        }
        playerImageView.tintColor = .gray
        playerImageView.loadImage(from: player.playerImage, placeholder: placeholder)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
            self.containerView.transform = highlighted ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
            self.containerView.backgroundColor = highlighted ? UIColor(red: 0.88, green: 0.93, blue: 0.88, alpha: 1.0) : UIColor(red: 0.93, green: 0.96, blue: 0.93, alpha: 1.0)
            self.containerView.layer.shadowOpacity = highlighted ? 0.0 : 0.08
        }
    }
}

