import UIKit
protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayData(upcoming: [Event], latest: [Event], teams: [Team])
    func reloadData()
    func toggleFavoriteState(isFavorite: Bool)
    func displayError(_ message: String)
}


class LeagueDetailsViewController: UIViewController, LeagueDetailsViewProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: LeagueDetailsPresenterProtocol!
    
    /// Set by the previous screen before pushing this VC
    var leagueId: Int!;
    var sportName: String!;
    
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let sectionTitles = ["Upcoming Events", "Latest Results", "Teams"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
        
        if presenter == nil {
            presenter = LeagueDetailsPresenter(
                view: self,
                leagueId: leagueId,
                sportName: sportName
            )
        }
        
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        title = "League Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .accent
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(resource: .accent)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(resource: .accent)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let heartIcon = UIImage(systemName: "heart")
        let favoriteButton = UIBarButtonItem(image: heartIcon, style: .plain, target: self, action: #selector(favoriteTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func setupActivityIndicator() {
        activityIndicator.color = .accent
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func favoriteTapped() {
        presenter.didTapFavorite()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "UpcomingEventCell", bundle: nil), forCellWithReuseIdentifier: "UpcomingEventCell")
        collectionView.register(LatestEventsContainerCell.self,
                                forCellWithReuseIdentifier: LatestEventsContainerCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "TeamCircularCell", bundle: nil), forCellWithReuseIdentifier: "TeamCircularCell")

        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                return self.createUpcomingEventsSection()
            case 1:
                return self.createLatestEventsSection()
            case 2:
                return self.createTeamsSection()
            default:
                return nil
            }
        }
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func createUpcomingEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.82), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 24, trailing: 0)
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.92
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width) * 0.15, minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return section
    }
    
    private func createLatestEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    private func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(90), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    // MARK: - LeagueDetailsViewProtocol
    func showLoading() {
        activityIndicator.startAnimating()
        collectionView.alpha = 0
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func displayData(upcoming: [Event], latest: [Event], teams: [Team]) {
        self.upcomingEvents = upcoming
        self.latestEvents = latest
        self.teams = teams
        self.reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func toggleFavoriteState(isFavorite: Bool) {
        let iconName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: iconName)
        navigationItem.rightBarButtonItem?.image = image
        
        // Animate the heart button
        if let barButtonView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView {
            UIView.animate(withDuration: 0.15, animations: {
                barButtonView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    barButtonView.transform = .identity
                }
            }
        }
    }
    
    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Section Header View
class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return upcomingEvents.count
        case 1: return latestEvents.isEmpty ? 0 : 1
        case 2: return teams.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
            cell.configure(with: upcomingEvents[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LatestEventsContainerCell.reuseIdentifier,
                for: indexPath
            ) as! LatestEventsContainerCell
            cell.configure(with: latestEvents)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCircularCell", for: indexPath) as! TeamCircularCell
            cell.configure(with: teams[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
        header.configure(title: sectionTitles[indexPath.section])
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController") as! TeamDetailsViewController;
            
            let selectedTeam = teams[indexPath.row]
            vc.team = selectedTeam
            vc.sportName = self.sportName
             self.navigationController?.pushViewController(vc, animated: true)
            presenter.didSelectTeam(at: indexPath.row)
        }
    }
}
