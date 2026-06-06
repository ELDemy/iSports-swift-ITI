import UIKit


class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var team: Team?
    var sportName: String!
    private var presenter: TeamDetailsPresenter!
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TeamDetailsPresenter(view: self, team: team, sportName: sportName)
        setupUI()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        activityIndicator.color = .systemGreen
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
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
    
}

extension TeamDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as? PlayerTableViewCell else {
            return UITableViewCell()
        }
        let player = presenter.player(at: indexPath)
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
        titleLabel.text = presenter.titleForSection(section)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let selectedPlayer = presenter.player(at: indexPath)
        let detailsVC = PlayerDetailsViewController()
        detailsVC.player = selectedPlayer
        
        if let navigationController = navigationController {
            navigationController.pushViewController(detailsVC, animated: true)
        } else {
            detailsVC.modalPresentationStyle = .fullScreen
            present(detailsVC, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TeamDetailsViewController: TeamDetailsViewProtocol {
    func displayTeamInfo(teamName: String?, logoUrl: String?) {
        title = teamName ?? "Team Details"
        teamNameLabel.text = teamName
        logoImageView.loadImage(from: logoUrl)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        tableView.alpha = 0
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
}
