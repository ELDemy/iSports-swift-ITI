import UIKit

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
    
    private enum Section: Int, CaseIterable {
        case header = 0, statistics, lineups, events
        
        var title: String {
            switch self {
            case .header: return ""
            case .statistics: return "Match Statistics"
            case .lineups: return "Starting Lineups"
            case .events: return "Match Events"
            }
        }
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
        
        // Register cells programmatically to avoid complex XIB setups in prompt
        tableView.register(MatchHeaderCell.self, forCellReuseIdentifier: MatchHeaderCell.identifier)
        tableView.register(MatchStatCell.self, forCellReuseIdentifier: MatchStatCell.identifier)
        tableView.register(MatchLineupCell.self, forCellReuseIdentifier: MatchLineupCell.identifier)
        tableView.register(MatchEventTimelineCell.self, forCellReuseIdentifier: MatchEventTimelineCell.identifier)
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
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MatchDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        switch sec {
        case .header: return event != nil ? 1 : 0
        case .statistics: return statistics.count
        case .lineups: return max(homeLineup.count, awayLineup.count)
        case .events: return matchEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sec = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch sec {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: MatchHeaderCell.identifier, for: indexPath) as! MatchHeaderCell
            if let event = event { cell.configure(with: event) }
            return cell
            
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = Section(rawValue: section) else { return nil }
        
        switch sec {
        case .statistics: return statistics.isEmpty ? nil : sec.title
        case .lineups: return (homeLineup.isEmpty && awayLineup.isEmpty) ? nil : sec.title
        case .events: return matchEvents.isEmpty ? nil : sec.title
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = self.tableView(tableView, titleForHeaderInSection: section) else { return nil }
        let header = UIView()
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(named: "accentColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard Section(rawValue: section) != .header else { return 0 }
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        return title == nil ? 0 : 40
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
