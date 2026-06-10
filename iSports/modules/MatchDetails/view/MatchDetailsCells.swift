import UIKit
import SkeletonView

class MatchHeaderCell: UITableViewCell {
    static let identifier = "MatchHeaderCell"
    
    private let homeLogo = UIImageView()
    private let awayLogo = UIImageView()
    private let homeLabel = UILabel()
    private let awayLabel = UILabel()
    private let scoreLabel = UILabel()
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        let container = UIView()
        container.isSkeletonable = true
        container.backgroundColor = UIColor(named: "CardBackground") ?? .secondarySystemBackground
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(named: "accentColor")?.withAlphaComponent(0.2).cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        [homeLogo, awayLogo].forEach {
            $0.isSkeletonable = true
            $0.skeletonCornerRadius = 30
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        [homeLabel, awayLabel].forEach {
            $0.isSkeletonable = true
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        scoreLabel.isSkeletonable = true
        scoreLabel.font = .systemFont(ofSize: 32, weight: .bold)
        scoreLabel.textColor = UIColor(named: "accentColor")
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.isSkeletonable = true
        statusLabel.font = .systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = .systemRed
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.isSkeletonable = true
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerStack = UIStackView(arrangedSubviews: [dateLabel, scoreLabel, statusLabel])
        centerStack.isSkeletonable = true
        centerStack.axis = .vertical
        centerStack.spacing = 4
        centerStack.alignment = .center
        centerStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(centerStack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            homeLogo.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            homeLogo.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10),
            homeLogo.widthAnchor.constraint(equalToConstant: 60),
            homeLogo.heightAnchor.constraint(equalToConstant: 60),
            
            homeLabel.topAnchor.constraint(equalTo: homeLogo.bottomAnchor, constant: 8),
            homeLabel.centerXAnchor.constraint(equalTo: homeLogo.centerXAnchor),
            homeLabel.widthAnchor.constraint(equalToConstant: 80),
            homeLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -16),
            
            awayLogo.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            awayLogo.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -10),
            awayLogo.widthAnchor.constraint(equalToConstant: 60),
            awayLogo.heightAnchor.constraint(equalToConstant: 60),
            
            awayLabel.topAnchor.constraint(equalTo: awayLogo.bottomAnchor, constant: 8),
            awayLabel.centerXAnchor.constraint(equalTo: awayLogo.centerXAnchor),
            awayLabel.widthAnchor.constraint(equalToConstant: 80),
            awayLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -16),
            
            centerStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            centerStack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func configure(with event: Event) {
        homeLabel.text = event.displayHomeName
        awayLabel.text = event.displayAwayName
        scoreLabel.text = event.displayResult
        dateLabel.text = event.displayDate
        statusLabel.text = event.eventStatus ?? "Finished"
        
        if let urlStr = event.displayHomeLogo {
            ImageLoader.shared.loadImage(from: urlStr, into: homeLogo)
        }
        if let urlStr = event.displayAwayLogo {
            ImageLoader.shared.loadImage(from: urlStr, into: awayLogo)
        }
    }
}

class MatchStatCell: UITableViewCell {
    static let identifier = "MatchStatCell"
    
    private let typeLabel = UILabel()
    private let homeLabel = UILabel()
    private let awayLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        let container = UIView()
        container.isSkeletonable = true
        container.backgroundColor = UIColor(named: "CardBackground") ?? .secondarySystemBackground
        container.layer.cornerRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        typeLabel.isSkeletonable = true
        typeLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        typeLabel.textColor = .secondaryLabel
        typeLabel.textAlignment = .center
        
        homeLabel.isSkeletonable = true
        homeLabel.font = .systemFont(ofSize: 15, weight: .bold)
        homeLabel.textColor = UIColor(named: "accentColor")
        homeLabel.textAlignment = .left
        
        awayLabel.isSkeletonable = true
        awayLabel.font = .systemFont(ofSize: 15, weight: .bold)
        awayLabel.textColor = UIColor(named: "accentColor")
        awayLabel.textAlignment = .right
        
        let stack = UIStackView(arrangedSubviews: [homeLabel, typeLabel, awayLabel])
        stack.isSkeletonable = true
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with stat: MatchStatistic) {
        typeLabel.text = stat.type?.uppercased()
        homeLabel.text = stat.home
        awayLabel.text = stat.away
    }
}

class MatchLineupCell: UITableViewCell {
    static let identifier = "MatchLineupCell"
    
    private let homeLabel = UILabel()
    private let awayLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        let container = UIView()
        container.isSkeletonable = true
        container.backgroundColor = UIColor(named: "CardBackground") ?? .secondarySystemBackground
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        homeLabel.isSkeletonable = true
        homeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        awayLabel.isSkeletonable = true
        awayLabel.font = .systemFont(ofSize: 14, weight: .medium)
        awayLabel.textAlignment = .right
        
        let stack = UIStackView(arrangedSubviews: [homeLabel, awayLabel])
        stack.isSkeletonable = true
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(homePlayer: LineupPlayer?, awayPlayer: LineupPlayer?) {
        if let hp = homePlayer {
            homeLabel.text = "\(hp.player_number ?? 0). \(hp.player ?? "")"
        } else {
            homeLabel.text = ""
        }
        
        if let ap = awayPlayer {
            awayLabel.text = "\(ap.player ?? "") .\(ap.player_number ?? 0)"
        } else {
            awayLabel.text = ""
        }
    }
}

class MatchEventTimelineCell: UITableViewCell {
    static let identifier = "MatchEventTimelineCell"
    
    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let detailLabel = UILabel()
    private let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        timeLabel.isSkeletonable = true
        timeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        timeLabel.textColor = .secondaryLabel
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconView.isSkeletonable = true
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        detailLabel.isSkeletonable = true
        detailLabel.font = .systemFont(ofSize: 14, weight: .medium)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lineView.isSkeletonable = true
        lineView.backgroundColor = .systemGray4
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(lineView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            lineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 2),
            
            timeLabel.centerXAnchor.constraint(equalTo: lineView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 34),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        timeLabel.backgroundColor = UIColor(named: "ViewBackground") ?? .systemGroupedBackground
    }
    
    func configure(with item: MatchEventItem) {
        timeLabel.text = item.timeString
        detailLabel.text = item.detail
        
        detailLabel.removeFromSuperview()
        contentView.addSubview(detailLabel)
        
        if item.isHome {
            detailLabel.textAlignment = .right
            NSLayoutConstraint.activate([
                iconView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
                detailLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -8),
                detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            ])
        } else {
            detailLabel.textAlignment = .left
            NSLayoutConstraint.activate([
                iconView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8),
                detailLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
                detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        }
        
        switch item.type {
        case .goal:
            iconView.image = UIImage(systemName: "soccerball")
            iconView.tintColor = .label
        case .yellowCard:
            iconView.image = UIImage(systemName: "rectangle.portrait.fill")
            iconView.tintColor = .systemYellow
        case .redCard:
            iconView.image = UIImage(systemName: "rectangle.portrait.fill")
            iconView.tintColor = .systemRed
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.removeFromSuperview()
        contentView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
