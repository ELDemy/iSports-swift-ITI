//import UIKit
//
//class PlayerDetailsViewController: UIViewController {
//
//    @IBOutlet weak var playerImageView: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var positionLabel: UILabel!
//    @IBOutlet weak var ageLabel: UILabel!
//    @IBOutlet weak var numberLabel: UILabel!
//    @IBOutlet weak var matchesLabel: UILabel!
//    @IBOutlet weak var goalsLabel: UILabel!
//    @IBOutlet weak var ratingLabel: UILabel!
//    
//    var player: Player?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        populateData()
//    }
//    
//    private func setupUI() {
//        title = "Player Details"
//        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 1.0)
//        playerImageView.layer.cornerRadius = 60
//        playerImageView.clipsToBounds = true
//        playerImageView.layer.borderWidth = 3
//        playerImageView.layer.borderColor = UIColor.systemGreen.cgColor
//    }
//    
//    private func populateData() {
//        guard let player = player else { return }
//        
//        nameLabel.text = player.playerName ?? "Unknown"
//        positionLabel.text = player.playerType ?? "Unknown Position"
//        ageLabel.text = "Age: \(player.playerAge ?? "N/A")"
//        numberLabel.text = "No. \(player.playerNumber ?? "-")"
//        
//        matchesLabel.text = "Matches: \(player.playerMatchPlayed ?? "0")"
//        
//        let goals = (player.playerGoals == nil || player.playerGoals == "") ? "0" : player.playerGoals!
//        goalsLabel.text = "Goals: \(goals)"
//        
//        ratingLabel.text = "Rating: \(player.playerRating ?? "N/A")"
//        
//        if let imageName = player.playerImage, let img = UIImage(named: imageName) {
//            playerImageView.image = img
//            playerImageView.tintColor = nil
//        } else {
//            playerImageView.image = UIImage(systemName: "person.circle.fill")
//            playerImageView.tintColor = .gray
//        }
//    }
//}
import UIKit

class PlayerDetailsViewController: UIViewController {

    // MARK: - UI Components
    private let backgroundGradientLayer = CAGradientLayer()
    
    private let playerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let imageShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 15
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(white: 1.0, alpha: 0.8)
        label.textAlignment = .center
        return label
    }()

    // Glassmorphism Card
    private let glassCardView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.layer.cornerRadius = 24
        effectView.clipsToBounds = true
        effectView.layer.borderWidth = 1
        effectView.layer.borderColor = UIColor(white: 1.0, alpha: 0.2).cgColor
        return effectView
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Data Properties
    var player: PlayerModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup UI & Layout
    private func setupUI() {
        title = "Player Profile"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Dynamic Gradient Background
        backgroundGradientLayer.colors = [
            UIColor(red: 0.05, green: 0.25, blue: 0.15, alpha: 1.0).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
        ]
        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        imageShadowView.addSubview(playerImageView)
        
        view.addSubview(imageShadowView)
        view.addSubview(nameLabel)
        view.addSubview(positionLabel)
        
        glassCardView.contentView.addSubview(statsStackView)
        view.addSubview(glassCardView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image Shadow & Image
            imageShadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageShadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageShadowView.widthAnchor.constraint(equalToConstant: 150),
            imageShadowView.heightAnchor.constraint(equalToConstant: 150),
            
            playerImageView.topAnchor.constraint(equalTo: imageShadowView.topAnchor),
            playerImageView.bottomAnchor.constraint(equalTo: imageShadowView.bottomAnchor),
            playerImageView.leadingAnchor.constraint(equalTo: imageShadowView.leadingAnchor),
            playerImageView.trailingAnchor.constraint(equalTo: imageShadowView.trailingAnchor),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: imageShadowView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Position Label
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            positionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            positionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Glass Card
            glassCardView.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 32),
            glassCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            glassCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            glassCardView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            // Stats Stack View inside Glass Card
            statsStackView.topAnchor.constraint(equalTo: glassCardView.contentView.topAnchor, constant: 24),
            statsStackView.bottomAnchor.constraint(equalTo: glassCardView.contentView.bottomAnchor, constant: -24),
            statsStackView.leadingAnchor.constraint(equalTo: glassCardView.contentView.leadingAnchor, constant: 24),
            statsStackView.trailingAnchor.constraint(equalTo: glassCardView.contentView.trailingAnchor, constant: -24)
        ])
    }
    
    private func createStatRow(iconName: String, title: String, value: String) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 16
        container.alignment = .center
        
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = .systemGreen
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = UIColor(white: 1.0, alpha: 0.7)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right
        
        container.addArrangedSubview(iconView)
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(valueLabel)
        
        return container
    }
    
    // MARK: - Data Ingestion
    private func populateData() {
        guard let player = player else { return }
        
        nameLabel.text = player.playerName ?? "Unknown"
        positionLabel.text = player.playerType?.uppercased() ?? "UNKNOWN POSITION"
        
        let age = player.playerAge ?? "N/A"
        let number = player.playerNumber ?? "-"
        let matches = player.playerMatchPlayed ?? "0"
        let goals = (player.playerGoals == nil || player.playerGoals == "") ? "0" : player.playerGoals!
        let rating = player.playerRating ?? "N/A"
        
        statsStackView.addArrangedSubview(createStatRow(iconName: "person.text.rectangle", title: "Age", value: age))
        statsStackView.addArrangedSubview(createStatRow(iconName: "number.circle", title: "Squad Number", value: number))
        statsStackView.addArrangedSubview(createStatRow(iconName: "sportscourt", title: "Matches Played", value: matches))
        statsStackView.addArrangedSubview(createStatRow(iconName: "soccerball", title: "Goals", value: goals))
        statsStackView.addArrangedSubview(createStatRow(iconName: "star.circle", title: "Rating", value: rating))
        
        let placeholder = UIImage(systemName: "person.crop.circle.fill")
        playerImageView.tintColor = .lightGray
        playerImageView.loadImage(from: player.playerImage, placeholder: placeholder)
    }
}
