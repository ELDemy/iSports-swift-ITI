import UIKit
import SkeletonView

class PlayerDetailsViewController: UIViewController {

    
    private let backgroundGradientLayer = CAGradientLayer()
    private let footballFieldLayer = CAShapeLayer()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let playerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0).cgColor
        return imageView
    }()
    
    private let imageShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 22
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .heavy)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.letterSpacing(1.5)
        return label
    }()

    
    private let glassCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let teamLogoBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.12
        return imageView
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    
    var player: PlayerModel?
    var sportName: String?
    private var presenter: PlayerDetailsPresenter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PlayerDetailsPresenter(view: self, player: player, sportName: sportName)
        setupNavigationBar()
        setupUI()
        setupSkeletonable()
        showLoading()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    
    private func setupNavigationBar() {
        if let sport = sportName, sport.lowercased() == "tennis" {
            title = "Tennis Player"
        } else {
            title = "Player Profile"
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backButtonAppearance = backItemAppearance

        let accent = UIColor(named: "accentColor") ?? .systemGreen
        
        let backImage = UIImage(systemName: "chevron.backward")?
            .withTintColor(accent, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(named: "accentColor")
    }
    
 
    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        imageShadowView.addSubview(playerImageView)
        contentView.addSubview(imageShadowView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(positionLabel)

        contentView.addSubview(glassCardView)
        glassCardView.addSubview(teamLogoBackgroundImageView)
        glassCardView.addSubview(statsStackView)

        setupConstraints()
    }
    
    private func setupSkeletonable() {
        scrollView.isSkeletonable = true
        contentView.isSkeletonable = true
        imageShadowView.isSkeletonable = true
        playerImageView.isSkeletonable = true
        playerImageView.skeletonCornerRadius = 70
        nameLabel.isSkeletonable = true
        positionLabel.isSkeletonable = true
        glassCardView.isSkeletonable = true
        statsStackView.isSkeletonable = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            imageShadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            imageShadowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageShadowView.widthAnchor.constraint(equalToConstant: 140),
            imageShadowView.heightAnchor.constraint(equalToConstant: 140),
            
            playerImageView.topAnchor.constraint(equalTo: imageShadowView.topAnchor),
            playerImageView.bottomAnchor.constraint(equalTo: imageShadowView.bottomAnchor),
            playerImageView.leadingAnchor.constraint(equalTo: imageShadowView.leadingAnchor),
            playerImageView.trailingAnchor.constraint(equalTo: imageShadowView.trailingAnchor),
            
            
            nameLabel.topAnchor.constraint(equalTo: imageShadowView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            positionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            positionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            
            glassCardView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 28),
            glassCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            glassCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            glassCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            
            teamLogoBackgroundImageView.centerXAnchor.constraint(equalTo: glassCardView.centerXAnchor),
            teamLogoBackgroundImageView.centerYAnchor.constraint(equalTo: glassCardView.centerYAnchor),
            teamLogoBackgroundImageView.widthAnchor.constraint(equalTo: glassCardView.widthAnchor, multiplier: 0.7),
            teamLogoBackgroundImageView.heightAnchor.constraint(equalTo: glassCardView.heightAnchor, multiplier: 0.7),

            statsStackView.topAnchor.constraint(equalTo: glassCardView.topAnchor, constant: 24),
            statsStackView.bottomAnchor.constraint(equalTo: glassCardView.bottomAnchor, constant: -24),
            statsStackView.leadingAnchor.constraint(equalTo: glassCardView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: glassCardView.trailingAnchor, constant: -20),
        ])
    }
    
    private func createStatRow(iconName: String, title: String, value: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.systemGray5

        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = UIColor(named: "accentColor")?.withAlphaComponent(0.12) ?? UIColor.systemGreen.withAlphaComponent(0.12)
        iconContainer.layer.cornerRadius = 18
        iconContainer.layer.borderWidth = 1
        iconContainer.layer.borderColor = UIColor(named: "accentColor")?.withAlphaComponent(0.3).cgColor ?? UIColor.systemGreen.withAlphaComponent(0.3).cgColor

        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = UIColor(named: "accentColor") ?? .systemGreen
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)

        container.addSubview(separator)
        container.addSubview(iconContainer)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: container.topAnchor),
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),

            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),

            container.heightAnchor.constraint(equalToConstant: 58)
        ])

        return container
    }
}


private extension UILabel {
    func letterSpacing(_ spacing: CGFloat) {
        if let text = self.text {
            let attributed = NSAttributedString(string: text, attributes: [.kern: spacing])
            self.attributedText = attributed
        }
    }
}

//extension PlayerDetailsViewController: PlayerDetailsViewProtocol {
//    func displayPlayerDetails(player: PlayerModel?, imageUrl: String?) {
//        nameLabel.text = player?.playerName
//        
//        positionLabel.text = player?.playerType?.uppercased()
//        
//        let placeholder: UIImage?
//        if player?.playerType == "Goalkeepers" {
//            placeholder = UIImage(named: "goalkeeper")
//        } else {
//            placeholder = UIImage(named: "player")
//        }
//        playerImageView.loadImage(from: imageUrl, placeholder: placeholder)
//        
//        if let teamLogoUrl = player?.playerLogo {
//            teamLogoBackgroundImageView.loadImage(from: teamLogoUrl)
//        }
//    }
//    
//    func displayPlayerStats(stats: [(iconName: String, title: String, value: String)]) {
//        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        for (index, stat) in stats.enumerated() {
//            let row = createStatRow(iconName: stat.iconName, title: stat.title, value: stat.value)
//           
//            if index == 0, let separator = row.subviews.first {
//                separator.isHidden = true
//            }
//            statsStackView.addArrangedSubview(row)
//        }
//    }
//}
extension PlayerDetailsViewController: PlayerDetailsViewProtocol {

    func showLoading() {
        let gradient = SkeletonGradient(
            baseColor: UIColor.systemGray5,
            secondaryColor: UIColor.systemGray4
        )
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        playerImageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        nameLabel.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        positionLabel.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        glassCardView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }

    func hideLoading() {
        playerImageView.hideSkeleton()
        nameLabel.hideSkeleton()
        positionLabel.hideSkeleton()
        glassCardView.hideSkeleton()
    }

    func displayPlayerDetails(player: PlayerModel?, imageUrl: String?) {
        if let name = player?.playerName, !name.isEmpty {
            nameLabel.text = name
        } else {
            nameLabel.text = "-"
        }

        if let sport = sportName, sport.lowercased() == "tennis" {
            // For tennis show country as the subtitle; hide position label if no country
            let country = player?.playerCountry ?? ""
            if country.isEmpty {
                positionLabel.isHidden = true
            } else {
                positionLabel.isHidden = false
                positionLabel.text = country.uppercased()
            }
            // Use the player logo as the image
            playerImageView.loadImage(from: imageUrl)
            if let logoUrl = imageUrl {
                teamLogoBackgroundImageView.loadImage(from: logoUrl)
            }
        } else {
            positionLabel.isHidden = false
            positionLabel.text = player?.playerType?.uppercased() ?? "-"

            let placeholder: UIImage?
            if player?.playerType == "Goalkeepers" {
                placeholder = UIImage(named: "goalkeeper")
            } else {
                placeholder = UIImage(named: "player")
            }
            playerImageView.loadImage(from: imageUrl, placeholder: placeholder)

            if let teamLogoUrl = player?.playerLogo {
                teamLogoBackgroundImageView.loadImage(from: teamLogoUrl)
            }
        }
    }

    func displayPlayerStats(stats: [(iconName: String, title: String, value: String)]) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, stat) in stats.enumerated() {
            let cleanedValue = stat.value.trimmingCharacters(in: .whitespacesAndNewlines)
            let displayValue = cleanedValue.isEmpty ? "-" : stat.value

            let row = createStatRow(iconName: stat.iconName, title: stat.title, value: displayValue)

            if index == 0, let separator = row.subviews.first {
                separator.isHidden = true
            }
            statsStackView.addArrangedSubview(row)
        }
        // Hide shimmer once all stats have been populated
        hideLoading()
    }
}
