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
private enum LeagueSection: Int, CaseIterable {
    case upcoming = 0, latest, teams

    func title(for sportName: String) -> String {
        switch self {
        case .upcoming: return "Upcoming Events"
        case .latest:   return "Latest Results"
        case .teams:    return sportName.lowercased() == "tennis" ? "Players" : "Teams"
        }
    }

    var emptyIcon: String {
        switch self {
        case .upcoming: return "calendar.badge.clock"
        case .latest:   return "flag.checkered"
        case .teams:    return "person.3.fill"
        }
    }

    var emptyMessage: String {
        switch self {
        case .upcoming: return "No upcoming events"
        case .latest:   return "No results yet"
        case .teams:    return "No teams available"
        }
    }
}

// MARK: - LeagueDetailsViewController
class LeagueDetailsViewController: UIViewController, LeagueDetailsViewProtocol {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Public (set by previous screen)
    var presenter:   LeagueDetailsPresenterProtocol!
    var leagueId:    Int    = 766
    var sportName:   String = "basketball"
    var leagueName:  String = "League Details"

    // MARK: - Private Data
    private var upcomingEvents: [Event] = []
    private var latestEvents:   [Event] = []
    private var teams:          [Team]  = []
    private var currentSportName: String = "basketball"

    // MARK: - UI
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
        initPresenterIfNeeded()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
    private func initPresenterIfNeeded() {
        guard presenter == nil else { return }
        presenter = LeagueDetailsPresenter(
            view:       self,
            leagueId:   leagueId,
            sportName:  sportName,
            leagueName: leagueName
        )
    }

    private func setupNavigationBar() {
        title = leagueName
        navigationController?.navigationBar.prefersLargeTitles = false

        let accent = UIColor(named: "accentColor") ?? UIColor(red: 1/255, green: 71/255, blue: 81/255, alpha: 1)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor           = UIColor(named: "background") ?? .systemBackground
        appearance.titleTextAttributes       = [.foregroundColor: accent, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        appearance.largeTitleTextAttributes  = [.foregroundColor: accent]
        navigationController?.navigationBar.standardAppearance  = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor           = accent

        let heartIcon      = UIImage(systemName: "heart")
        let favoriteButton = UIBarButtonItem(image: heartIcon, style: .plain, target: self, action: #selector(favoriteTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    private func setupActivityIndicator() {
        activityIndicator.color = UIColor(named: "accentColor")
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupCollectionView() {
        // Cells
        collectionView.register(UINib(nibName: "UpcomingEventCell", bundle: nil),
                                forCellWithReuseIdentifier: "UpcomingEventCell")
        collectionView.register(LatestEventsContainerCell.self,
                                forCellWithReuseIdentifier: LatestEventsContainerCell.reuseIdentifier)
        collectionView.register(UINib(nibName: "TeamCircularCell", bundle: nil),
                                forCellWithReuseIdentifier: "TeamCircularCell")
        collectionView.register(EmptySectionCell.self,
                                forCellWithReuseIdentifier: EmptySectionCell.reuseIdentifier)

        // Header
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        collectionView.collectionViewLayout = makeCompositionalLayout()
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.backgroundColor = UIColor(named: "ViewBackground") ?? .systemGroupedBackground
    }

    // MARK: - Compositional Layout
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] index, _ in
            guard let self, let section = LeagueSection(rawValue: index) else { return nil }
            switch section {
            case .upcoming: return self.upcomingSection()
            case .latest:   return self.latestSection()
            case .teams:    return self.teamsSection()
            }
        }
    }

    private func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(52))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: size,
                                                          elementKind: UICollectionView.elementKindSectionHeader,
                                                          alignment: .top)
    }

    private func upcomingSection() -> NSCollectionLayoutSection {
        let isEmpty = upcomingEvents.isEmpty
        let height: CGFloat = isEmpty ? 140 : 130
        let widthDim: NSCollectionLayoutDimension = isEmpty ? .fractionalWidth(1) : .fractionalWidth(0.82)

        let item  = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: widthDim, heightDimension: .absolute(height)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = isEmpty ? .none : .groupPagingCentered
        section.interGroupSpacing  = 16
        section.contentInsets      = .init(top: 8, leading: isEmpty ? 16 : 0, bottom: 24, trailing: isEmpty ? 16 : 0)
        section.boundarySupplementaryItems = [sectionHeader()]

        if !isEmpty {
            section.visibleItemsInvalidationHandler = { items, offset, env in
                items.forEach { item in
                    let dist  = abs((item.frame.midX - offset.x) - env.container.contentSize.width / 2)
                    let scale = max(1.0 - (dist / env.container.contentSize.width) * 0.15, 0.92)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        return section
    }

    private func latestSection() -> NSCollectionLayoutSection {
        let isEmpty = latestEvents.isEmpty
        let height: CGFloat = isEmpty ? 140 : 320

        let item  = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 16, bottom: 24, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader()]
        return section
    }

    private func teamsSection() -> NSCollectionLayoutSection {
        let isEmpty = teams.isEmpty
        let width:  CGFloat = isEmpty ? UIScreen.main.bounds.width - 32 : 90
        let height: CGFloat = isEmpty ? 140 : 110
        let widthDim: NSCollectionLayoutDimension = isEmpty ? .fractionalWidth(1) : .absolute(width)

        let item  = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: widthDim, heightDimension: .absolute(height)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = isEmpty ? .none : .continuous
        section.interGroupSpacing  = 12
        section.contentInsets      = .init(top: 8, leading: 16, bottom: 24, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader()]
        return section
    }

    // MARK: - LeagueDetailsViewProtocol
    func showLoading() {
        activityIndicator.startAnimating()
        collectionView.alpha = 0
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.4) { self.collectionView.alpha = 1 }
    }

    func setLeagueName(_ name: String, sportName: String) {
        self.currentSportName = sportName
        DispatchQueue.main.async {
            self.title = name
        }
    }

    func displayData(upcoming: [Event], latest: [Event], teams: [Team]) {
        self.upcomingEvents = upcoming
        self.latestEvents   = latest
        self.teams          = teams
        reloadData()
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }

    func toggleFavoriteState(isFavorite: Bool) {
        let name  = isFavorite ? "heart.fill" : "heart"
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: name)
        }
        animateHeartButton()
    }

    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Actions
    @objc private func favoriteTapped() { presenter.didTapFavorite() }

    private func animateHeartButton() {
        guard let barView = navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView else { return }
        UIView.animate(withDuration: 0.15, animations: {
            barView.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        }) { _ in
            UIView.animate(withDuration: 0.15) { barView.transform = .identity }
        }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        LeagueSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sec = LeagueSection(rawValue: section) else { return 0 }
        switch sec {
        case .upcoming: return max(upcomingEvents.count, 1)   // 1 = empty state cell
        case .latest:   return 1                              // container cell (handles empty internally)
        case .teams:    return max(teams.count, 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {

        case .upcoming:
            if upcomingEvents.isEmpty {
                return emptyCell(for: collectionView, at: indexPath, section: .upcoming)
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell",
                                                          for: indexPath) as! UpcomingEventCell
            cell.configure(with: upcomingEvents[indexPath.row])
            return cell

        case .latest:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LatestEventsContainerCell.reuseIdentifier,
                for: indexPath) as! LatestEventsContainerCell
            cell.configure(with: latestEvents)
            return cell

        case .teams:
            if teams.isEmpty {
                return emptyCell(for: collectionView, at: indexPath, section: .teams)
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCircularCell",
                                                          for: indexPath) as! TeamCircularCell
            cell.configure(with: teams[indexPath.row])
            return cell
        }
    }

    private func emptyCell(for cv: UICollectionView,
                           at indexPath: IndexPath,
                           section: LeagueSection) -> EmptySectionCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: EmptySectionCell.reuseIdentifier,
                                          for: indexPath) as! EmptySectionCell
        cell.configure(icon: section.emptyIcon, message: section.emptyMessage)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as! SectionHeaderView

        if let section = LeagueSection(rawValue: indexPath.section) {
            let title = section.title(for: currentSportName)
            let count: Int? = {
                switch section {
                case .upcoming: return upcomingEvents.isEmpty ? nil : upcomingEvents.count
                case .latest:   return latestEvents.isEmpty   ? nil : latestEvents.count
                case .teams:    return teams.isEmpty           ? nil : teams.count
                }
            }()
            header.configure(title: title, count: count)
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == LeagueSection.teams.rawValue, !teams.isEmpty else { return }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController")
                as? TeamDetailsViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
        presenter.didSelectTeam(at: indexPath.row)
    }
}

// MARK: - SectionHeaderView
class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = UIColor(named: "accentColor")
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let countBadge: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = .white
        l.textAlignment = .center
        l.backgroundColor = UIColor(named: "accentColor")
        l.layer.cornerRadius = 10
        l.layer.masksToBounds = true
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        return l
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "accentColor")?.withAlphaComponent(0.25)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "ViewBackground") ?? .systemGroupedBackground

        addSubview(titleLabel)
        addSubview(countBadge)
        addSubview(separator)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -6),

            countBadge.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            countBadge.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            countBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 22),
            countBadge.heightAnchor.constraint(equalToConstant: 20),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            separator.heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String, count: Int?) {
        titleLabel.text = title
        if let count {
            countBadge.text  = " \(count) "
            countBadge.isHidden = false
        } else {
            countBadge.isHidden = true
        }
    }
}

// MARK: - EmptySectionCell
class EmptySectionCell: UICollectionViewCell {
    static let reuseIdentifier = "EmptySectionCell"

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor       = UIColor(named: "accentColor")?.withAlphaComponent(0.45)
        iv.contentMode     = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font          = .systemFont(ofSize: 14, weight: .medium)
        l.textColor     = UIColor(named: "SecondaryText") ?? .secondaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let containerStack: UIStackView = {
        let sv = UIStackView()
        sv.axis      = .vertical
        sv.alignment = .center
        sv.spacing   = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor   = UIColor(named: "CardBackground")?.withAlphaComponent(0.55)
            ?? UIColor.secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        // Subtle border
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "accentColor")?.withAlphaComponent(0.15).cgColor

        containerStack.addArrangedSubview(iconView)
        containerStack.addArrangedSubview(messageLabel)
        contentView.addSubview(containerStack)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 46),
            iconView.heightAnchor.constraint(equalToConstant: 46),
            containerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(icon: String, message: String) {
        iconView.image    = UIImage(systemName: icon,
                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 36, weight: .thin))
        messageLabel.text = message
    }
}
