import UIKit
import SkeletonView

class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var team: Team?
    var sportName: String!
    private var presenter: TeamDetailsPresenter!

    private let backgroundGradientLayer = CAGradientLayer()
    private let fieldPatternLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TeamDetailsPresenter(view: self, team: team, sportName: sportName)
        setupBackground()
        setupNavigationBar()
        setupHeaderUI()
        setupTableView()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    

    private func setupBackground() {
        view.backgroundColor = .systemBackground
        tableView?.backgroundColor = .systemBackground
    }
    
  
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navigationController?.navigationBar.tintColor = UIColor(named: "accentColor")
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
    }
    
    
    private func setupHeaderUI() {
       
        logoImageView?.layer.cornerRadius = (logoImageView?.frame.width ?? 80) / 2
        logoImageView?.clipsToBounds = true
        logoImageView?.layer.borderWidth = 3
        logoImageView?.layer.borderColor = UIColor(named: "accentColor")?.cgColor ?? UIColor.systemGreen.cgColor
        
        // Make logo skeletonable
        logoImageView?.isSkeletonable = true
        logoImageView?.skeletonCornerRadius = Float((logoImageView?.frame.width ?? 80) / 2)
        
        teamNameLabel?.textColor = .label
        teamNameLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        teamNameLabel?.isSkeletonable = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerTableViewCell")
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none

        // Enable SkeletonView on the table
        tableView.isSkeletonable = true
    }
}


extension TeamDetailsViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PlayerTableViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return 1 while skeleton is showing so the table has a section to render into.
        // Once real data arrives, return the actual section count.
        return max(presenter.numberOfSections, 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Guard against accessing sections before data has loaded (skeleton phase)
        guard presenter.numberOfSections > 0, section < presenter.numberOfSections else { return 0 }
        return presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as? PlayerTableViewCell else {
            return UITableViewCell()
        }
        let player = presenter.player(at: indexPath)
        cell.configure(with: player)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard presenter.numberOfSections > 0 else { return nil }
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6
        headerView.layer.cornerRadius = 10
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: "person.3.fill"))
        iconImageView.tintColor = UIColor(named: "accentColor") ?? .systemGreen
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)

        let titleLabel = UILabel()
        titleLabel.text = presenter.titleForSection(section)
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .label

        let accentLine = UIView()
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        accentLine.backgroundColor = UIColor(named: "accentColor") ?? .systemGreen
        accentLine.layer.cornerRadius = 1.5

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        headerView.addSubview(stackView)
        headerView.addSubview(accentLine)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),

            accentLine.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            accentLine.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 6),
            accentLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -6),
            accentLine.widthAnchor.constraint(equalToConstant: 3)
        ])

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter.numberOfSections > 0 ? 48 : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sport = sportName?.lowercased() ?? ""
        if sport == "basketball" || sport == "cricket" {
            let alert = UIAlertController(
                title: "Coming Soon",
                message: "Player details for this sport will come up soon.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let selectedPlayer = presenter.player(at: indexPath)
        let detailsVC = PlayerDetailsViewController()
        detailsVC.player = selectedPlayer
        detailsVC.sportName = self.sportName
        
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
        teamNameLabel?.text = teamName
        teamNameLabel?.textColor = .label
        logoImageView?.loadImage(from: logoUrl)
        
        DispatchQueue.main.async {
            self.logoImageView?.layer.cornerRadius = (self.logoImageView?.frame.width ?? 80) / 2
            self.logoImageView?.clipsToBounds = true
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            let gradient = SkeletonGradient(
                baseColor: UIColor.systemGray5,
                secondaryColor: UIColor.systemGray4
            )
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
            self.tableView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
            self.logoImageView?.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
            self.teamNameLabel?.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.tableView.hideSkeleton(reloadDataAfter: true)
            self.logoImageView?.hideSkeleton()
            self.teamNameLabel?.hideSkeleton()
        }
    }
}
