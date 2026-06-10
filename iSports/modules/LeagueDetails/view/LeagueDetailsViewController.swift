import SkeletonView
import UIKit

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayData(upcoming: [Event], latest: [Event], teams: [Team])
    func reloadData()
    func toggleFavoriteState(isFavorite: Bool)
    func displayError(_ message: String)
    func setLeagueName(_ name: String, sportName: String)
}

enum LeagueSection: Int, CaseIterable {
    case upcoming, latest, teams

    func title(for sportName: String) -> String {
        switch self {
        case .upcoming: return L10n.leagueUpcomingEvents.localized
        case .latest: return L10n.leagueLatestResults.localized
        case .teams:
            return sportName.lowercased() == "tennis"
                ? L10n.leaguePlayers.localized : L10n.leagueTeams.localized
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
        case .upcoming: return L10n.leagueNoUpcoming.localized
        case .latest: return L10n.leagueNoResults.localized
        case .teams: return L10n.leagueNoTeams.localized
        }
    }
}

class LeagueDetailsViewController: UIViewController, LeagueDetailsViewProtocol {

    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: LeagueDetailsPresenterProtocol!
    var league: LeagueModel!
    var sportName: String!

    var upcomingEvents: [Event] = []
    var latestEvents: [Event] = []
    var teams: [Team] = []
    var currentSportName: String = ""

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
        presenter.viewDidLoad()
    }

    private func setupNavigationBar() {
        title = league.leagueName
        navigationController?.navigationBar.prefersLargeTitles = false

        let accent = UIColor(named: "accentColor") ?? .systemGreen
        let dynamicColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : accent
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: dynamicColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: dynamicColor]
        appearance.backButtonAppearance = backItemAppearance
        
        let backImage = UIImage(systemName: "chevron.backward")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicColor

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
                title: L10n.errorSomethingWentWrong.localized,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(title: L10n.ok.localized, style: .default)
            )
            self.present(alert, animated: true)
        }
    }
    

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

    @objc private func favoriteTapped() {
        if(presenter.checkIsFavorite()){
           confirmDeletion()
        }else{
            presenter.didTapFavorite()
        }
    }
    func confirmDeletion() {
        let alert = UIAlertController(
            title: "Remove from Favorites",
            message: "Are you sure you want to remove this league from your favorites?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            presenter.didTapFavorite()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

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
