import UIKit

struct PositionSection {
    let title: String
    let players: [PlayerModel]
}

class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var team: Team?
    private var sections: [PositionSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadData()
    }
    
    private func setupUI() {
        title = team?.teamName ?? "Team Details"
        teamNameLabel.text = team?.teamName
        logoImageView.loadImage(from: team?.teamLogo)
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        backButton.tintColor = .systemGreen
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc private func backButtonTapped() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerTableViewCell")
    }
    
    private func loadData() {
        let allPlayers = team != nil ? (team?.players ?? []) : PlayerMockData.getAllPlayers()
        
        let goalkeepers = allPlayers.filter { $0.playerType == "Goalkeepers" }
        let defenders = allPlayers.filter { $0.playerType == "Defenders" }
        let midfielders = allPlayers.filter { $0.playerType == "Midfielders" }
        let forwards = allPlayers.filter { $0.playerType == "Forwards" }
        
        sections = []
        if !goalkeepers.isEmpty { sections.append(PositionSection(title: "GOALKEEPERS", players: goalkeepers)) }
        if !defenders.isEmpty { sections.append(PositionSection(title: "DEFENDERS", players: defenders)) }
        if !midfielders.isEmpty { sections.append(PositionSection(title: "MIDFIELDERS", players: midfielders)) }
        if !forwards.isEmpty { sections.append(PositionSection(title: "FORWARDS", players: forwards)) }
        
        tableView.reloadData()
    }
}

extension TeamDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as? PlayerTableViewCell else {
            return UITableViewCell()
        }
        let player = sections[indexPath.section].players[indexPath.row]
        cell.configure(with: player)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView(image: UIImage(systemName: "hand.raised.fill"))
        iconImageView.tintColor = .systemGreen
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        let titleLabel = UILabel()
        titleLabel.text = sections[section].title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 1. Get the selected player from your sections array
//        let selectedPlayer = sections[indexPath.section].players[indexPath.row]
//        
//        // 2. Instantiate PlayerDetailsViewController from the Main storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "PlayerDetailsViewController") as? PlayerDetailsViewController else {
//            print("Error: Could not find PlayerDetailsViewController with that Storyboard ID.")
//            return
//        }
//        
//        // 3. Pass the selected player data to the details view controller
//        detailsVC.player = selectedPlayer
//        
//        // 4. Navigate to the next screen
//        if let navigationController = navigationController {
//            // Push onto the navigation stack if you are inside a Navigation Controller
//            navigationController.pushViewController(detailsVC, animated: true)
//        } else {
//            // Fallback: Present it modally if there's no navigation controller
//            detailsVC.modalPresentationStyle = .fullScreen
//            present(detailsVC, animated: true, completion: nil)
//        }
//        
//        // 5. Deselect the row so it doesn't stay highlighted gray
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Fetch your model instance
        let selectedPlayer = sections[indexPath.section].players[indexPath.row]
        
        // 2. Initialize your controller programmatically directly
        let detailsVC = PlayerDetailsViewController()
        detailsVC.player = selectedPlayer
        
        // 3. Navigate cleanly via Navigation Stack or fallback to modal
        if let navigationController = navigationController {
            navigationController.pushViewController(detailsVC, animated: true)
        } else {
            detailsVC.modalPresentationStyle = .fullScreen
            present(detailsVC, animated: true, completion: nil)
        }
        
        // 4. Deselect gray highlight line row selection visual effect
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
