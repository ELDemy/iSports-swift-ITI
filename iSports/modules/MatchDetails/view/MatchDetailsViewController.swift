import UIKit
import SkeletonView

class MatchDetailsViewController: UIViewController, MatchDetailsViewProtocol {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public Properties
    var presenter: MatchDetailsPresenterProtocol!
    
    // MARK: - Private Properties
    private var event: Event?
    private var statistics: [MatchStatistic] = []
    private var homeLineup: [LineupPlayer] = []
    private var awayLineup: [LineupPlayer] = []
    private var goalscorers: [MatchGoalscorer] = []
    private var cards: [MatchCard] = []
    
    // Timeline events combined
    private var matchEvents: [MatchEventItem] = []
    
    private enum Tab: Int, CaseIterable {
        case statistics = 0, lineups, events
        var title: String {
            switch self {
            case .statistics: return "Statistics"
            case .lineups: return "Lineups"
            case .events: return "Events"
            }
        }
    }
    
    private var selectedTab: Tab = .statistics
    
    private enum Section: Int, CaseIterable {
        case header = 0, content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Match Details"
        view.backgroundColor = UIColor(named: "ViewBackground") ?? .systemGroupedBackground
        
        if tableView == nil {
            let tv = UITableView(frame: view.bounds, style: .grouped)
            tv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(tv)
            self.tableView = tv
        }
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isSkeletonable = true
        
        // Register cells programmatically to avoid complex XIB setups in prompt
        tableView.register(MatchHeaderCell.self, forCellReuseIdentifier: MatchHeaderCell.identifier)
        tableView.register(MatchStatCell.self, forCellReuseIdentifier: MatchStatCell.identifier)
        tableView.register(MatchLineupCell.self, forCellReuseIdentifier: MatchLineupCell.identifier)
        tableView.register(MatchEventTimelineCell.self, forCellReuseIdentifier: MatchEventTimelineCell.identifier)
    }
    
    @objc private func tabChanged(_ sender: UISegmentedControl) {
        guard let tab = Tab(rawValue: sender.selectedSegmentIndex) else { return }
        selectedTab = tab
        tableView.reloadSections(IndexSet(integer: Section.content.rawValue), with: .fade)
    }
    
    // MARK: - MatchDetailsViewProtocol
    func displayMatchInfo(_ event: Event) {
        self.event = event
        tableView.reloadData()
    }
    
    func displayStatistics(_ stats: [MatchStatistic]) {
        self.statistics = stats
        tableView.reloadData()
    }
    
    func displayLineups(home: [LineupPlayer], away: [LineupPlayer]) {
        self.homeLineup = home
        self.awayLineup = away
        tableView.reloadData()
    }
    
    func displayGoalscorers(_ scorers: [MatchGoalscorer]) {
        self.goalscorers = scorers
        buildTimeline()
    }
    
    func displayCards(_ cards: [MatchCard]) {
        self.cards = cards
        buildTimeline()
    }
    
    private func buildTimeline() {
        var items: [MatchEventItem] = []
        
        for goal in goalscorers {
            if let timeStr = goal.time, let time = Int(timeStr.replacingOccurrences(of: "'", with: "")) {
                let isHome = (goal.home_scorer != nil && goal.home_scorer != "")
                let player = isHome ? goal.home_scorer : goal.away_scorer
                items.append(MatchEventItem(time: time, timeString: timeStr, type: .goal, isHome: isHome, detail: player ?? ""))
            }
        }
        
        for card in cards {
            if let timeStr = card.time, let time = Int(timeStr.components(separatedBy: "+")[0].replacingOccurrences(of: "'", with: "")) {
                let isHome = (card.home_fault != nil && card.home_fault != "")
                let player = isHome ? card.home_fault : card.away_fault
                let type: MatchEventType = (card.card?.lowercased().contains("red") == true) ? .redCard : .yellowCard
                items.append(MatchEventItem(time: time, timeString: timeStr, type: type, isHome: isHome, detail: player ?? ""))
            }
        }
        
        matchEvents = items.sorted(by: { $0.time < $1.time })
        tableView.reloadData()
    }
    
    func showLoading() {
        let gradient = getSkeletonGradient()
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        tableView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
    
    func hideLoading() {
        tableView.hideSkeleton(reloadDataAfter: true)
    }
    
    private func getSkeletonGradient() -> SkeletonGradient {
        if traitCollection.userInterfaceStyle == .dark {
            return SkeletonGradient(
                baseColor: UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1.0),
                secondaryColor: UIColor(red: 0.20, green: 0.20, blue: 0.22, alpha: 1.0)
            )
        } else {
            return SkeletonGradient(
                baseColor: UIColor(red: 0.90, green: 0.90, blue: 0.92, alpha: 1.0),
                secondaryColor: UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.0)
            )
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MatchDetailsViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        guard let sec = Section(rawValue: indexPath.section) else { return MatchStatCell.identifier }
        switch sec {
        case .header:
            return MatchHeaderCell.identifier
        case .content:
            switch selectedTab {
            case .statistics: return MatchStatCell.identifier
            case .lineups: return MatchLineupCell.identifier
            case .events: return MatchEventTimelineCell.identifier
            }
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        switch sec {
        case .header: return 1
        case .content: return 4
        }
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        switch sec {
        case .header: return event != nil ? 1 : 0
        case .content:
            switch selectedTab {
            case .statistics: return statistics.count
            case .lineups: return max(homeLineup.count, awayLineup.count)
            case .events: return matchEvents.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sec {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchHeaderCell.identifier, for: indexPath) as! MatchHeaderCell
            if let event = event { cell.configure(with: event) }
            return cell
            
        case .content:
            switch selectedTab {
            case .statistics:
                let cell = tableView.dequeueReusableCell(withIdentifier: MatchStatCell.identifier, for: indexPath) as! MatchStatCell
                cell.configure(with: statistics[indexPath.row])
                return cell
                
            case .lineups:
                let cell = tableView.dequeueReusableCell(withIdentifier: MatchLineupCell.identifier, for: indexPath) as! MatchLineupCell
                let homeP = indexPath.row < homeLineup.count ? homeLineup[indexPath.row] : nil
                let awayP = indexPath.row < awayLineup.count ? awayLineup[indexPath.row] : nil
                cell.configure(homePlayer: homeP, awayPlayer: awayP)
                return cell
                
            case .events:
                let cell = tableView.dequeueReusableCell(withIdentifier: MatchEventTimelineCell.identifier, for: indexPath) as! MatchEventTimelineCell
                cell.configure(with: matchEvents[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sec = Section(rawValue: section), sec == .content else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ViewBackground") ?? .systemGroupedBackground
        
        let items = Tab.allCases.map { $0.title }
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = selectedTab.rawValue
        sc.addTarget(self, action: #selector(tabChanged(_:)), for: .valueChanged)
        
        sc.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(sc)
        
        NSLayoutConstraint.activate([
            sc.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            sc.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
            sc.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            sc.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sec = Section(rawValue: section), sec == .content else { return .leastNormalMagnitude }
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK: - Timeline Helpers
enum MatchEventType {
    case goal, yellowCard, redCard
}

struct MatchEventItem {
    let time: Int
    let timeString: String
    let type: MatchEventType
    let isHome: Bool
    let detail: String
}
