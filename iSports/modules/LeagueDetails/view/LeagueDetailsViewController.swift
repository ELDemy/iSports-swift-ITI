import SkeletonView
import UIKit

// MARK: - View Protocol
protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayData(upcoming: [Event], latest: [Event], teams: [Team])
    func reloadData()
    func toggleFavoriteState(isFavorite: Bool)
    func displayError(_ message: String)
    func setLeagueName(_ name: String, sportName: String)
}

// MARK: - Section Enum
enum LeagueSection: Int, CaseIterable {
    case upcoming, latest, teams

    func title(for sportName: String) -> String {
        switch self {
        case .upcoming: return "Upcoming Events"
        case .latest: return "Latest Results"
        case .teams:
            return sportName.lowercased() == "tennis" ? "Players" : "Teams"
        }
    }

    var emptyIcon: String {
        switch self {
        case .upcoming: return "calendar.badge.clock"
        case .latest: return "flag.checkered"
        case .teams: return "person.3.fill"
        }
    }

    var emptyMessage: String {
        switch self {
        case .upcoming: return "No upcoming events"
        case .latest: return "No results yet"
        case .teams: return "No teams available"
        }
    }
}

// MARK: - LeagueDetailsViewController
class LeagueDetailsViewController: UIViewController, LeagueDetailsViewProtocol {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Dependencies (set by AppRouter before push)
    var presenter: LeagueDetailsPresenterProtocol!
    var league: LeagueModel!
    var sportName: String!

    // MARK: - Private Data
    var upcomingEvents: [Event] = []
    var latestEvents: [Event] = []
    var teams: [Team] = []
    var currentSportName: String = ""

    // MARK: - UI
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        title = league.leagueName
        navigationController?.navigationBar.prefersLargeTitles = false

        let accent =
            UIColor(named: "accentColor")
            ?? UIColor(red: 1 / 255, green: 71 / 255, blue: 81 / 255, alpha: 1)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor =
            UIColor(named: "background") ?? .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: accent,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
        ]
        appearance.largeTitleTextAttributes = [.foregroundColor: accent]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = accent

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
    }

    private func setupActivityIndicator() {
        activityIndicator.color = UIColor(named: "accentColor")
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
        ])
    }

    private func setupCollectionView() {
        collectionView.register(
            UINib(nibName: "UpcomingEventCell", bundle: nil),
            forCellWithReuseIdentifier: "UpcomingEventCell"
        )
        collectionView.register(
            LatestEventsContainerCell.self,
            forCellWithReuseIdentifier: LatestEventsContainerCell
                .reuseIdentifier
        )
        collectionView.register(
            UINib(nibName: "TeamCircularCell", bundle: nil),
            forCellWithReuseIdentifier: "TeamCircularCell"
        )
        collectionView.register(
            EmptySectionCell.self,
            forCellWithReuseIdentifier: EmptySectionCell.reuseIdentifier
        )
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )

        collectionView.collectionViewLayout = makeCompositionalLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor =
            UIColor(named: "ViewBackground") ?? .systemGroupedBackground
        collectionView.isSkeletonable = true
    }

    // MARK: - Compositional Layout
    private func makeCompositionalLayout()
        -> UICollectionViewCompositionalLayout
    {
        UICollectionViewCompositionalLayout { [weak self] index, _ in
            guard let self, let section = LeagueSection(rawValue: index) else {
                return nil
            }
            switch section {
            case .upcoming: return self.upcomingSection()
            case .latest: return self.latestSection()
            case .teams: return self.teamsSection()
            }
        }
    }

    private func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem
    {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(52)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    private func upcomingSection() -> NSCollectionLayoutSection {
        let isEmpty = upcomingEvents.isEmpty
        let height: CGFloat = isEmpty ? 140 : 130
        let widthDim: NSCollectionLayoutDimension =
            isEmpty ? .fractionalWidth(1) : .fractionalWidth(0.82)

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: widthDim,
                heightDimension: .absolute(height)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior =
            isEmpty ? .none : .groupPagingCentered
        section.interGroupSpacing = 16
        section.contentInsets = .init(
            top: 8,
            leading: isEmpty ? 16 : 0,
            bottom: 24,
            trailing: isEmpty ? 16 : 0
        )
        section.boundarySupplementaryItems = [sectionHeader()]

        if !isEmpty {
            section.visibleItemsInvalidationHandler = { items, offset, env in
                items.forEach { item in
                    let dist = abs(
                        (item.frame.midX - offset.x) - env.container.contentSize
                            .width / 2
                    )
                    let scale = max(
                        1.0 - (dist / env.container.contentSize.width) * 0.15,
                        0.92
                    )
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        return section
    }

    private func latestSection() -> NSCollectionLayoutSection {
        let height: CGFloat = latestEvents.isEmpty ? 140 : 320
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(height)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 8,
            leading: 16,
            bottom: 24,
            trailing: 16
        )
        section.boundarySupplementaryItems = [sectionHeader()]
        return section
    }

    private func teamsSection() -> NSCollectionLayoutSection {
        let isEmpty = teams.isEmpty
        let width: CGFloat = isEmpty ? UIScreen.main.bounds.width - 32 : 90
        let height: CGFloat = isEmpty ? 140 : 110
        let widthDim: NSCollectionLayoutDimension =
            isEmpty ? .fractionalWidth(1) : .absolute(width)

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: widthDim,
                heightDimension: .absolute(height)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = isEmpty ? .none : .continuous
        section.interGroupSpacing = 12
        section.contentInsets = .init(
            top: 8,
            leading: 16,
            bottom: 24,
            trailing: 16
        )
        section.boundarySupplementaryItems = [sectionHeader()]
        return section
    }

    // MARK: - LeagueDetailsViewProtocol
    func showLoading() {
        let gradient = skeletonGradient()
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(
            withDirection: .leftRight
        )
        collectionView.showAnimatedGradientSkeleton(
            usingGradient: gradient,
            animation: animation
        )
    }

    func hideLoading() {
        collectionView.hideSkeleton(reloadDataAfter: true)
    }

    func setLeagueName(_ name: String, sportName: String) {
        currentSportName = sportName
        DispatchQueue.main.async { self.title = name }
    }

    func displayData(upcoming: [Event], latest: [Event], teams: [Team]) {
        upcomingEvents = upcoming
        latestEvents = latest
        self.teams = teams
        reloadData()
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }

    func toggleFavoriteState(isFavorite: Bool) {
        let iconName = isFavorite ? "star.fill" : "star"
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.image = UIImage(
                systemName: iconName
            )
        }
        animateHeartButton()
    }

    func displayError(_ message: String) {
        DispatchQueue.main.async {
            self.collectionView.hideSkeleton()
            let alert = UIAlertController(
                title: "Something went wrong",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Private Helpers
    private func skeletonGradient() -> SkeletonGradient {
        if traitCollection.userInterfaceStyle == .dark {
            return SkeletonGradient(
                baseColor: UIColor(
                    red: 0.12,
                    green: 0.12,
                    blue: 0.14,
                    alpha: 1
                ),
                secondaryColor: UIColor(
                    red: 0.20,
                    green: 0.20,
                    blue: 0.22,
                    alpha: 1
                )
            )
        } else {
            return SkeletonGradient(
                baseColor: UIColor(
                    red: 0.90,
                    green: 0.90,
                    blue: 0.92,
                    alpha: 1
                ),
                secondaryColor: UIColor(
                    red: 0.96,
                    green: 0.96,
                    blue: 0.98,
                    alpha: 1
                )
            )
        }
    }

    // MARK: - Actions
    @objc private func favoriteTapped() { presenter.didTapFavorite() }

    private func animateHeartButton() {
        guard
            let barView = navigationItem.rightBarButtonItem?.value(
                forKey: "view"
            ) as? UIView
        else { return }
        UIView.animate(
            withDuration: 0.15,
            animations: {
                barView.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            }
        ) { _ in
            UIView.animate(withDuration: 0.15) { barView.transform = .identity }
        }
    }
}
