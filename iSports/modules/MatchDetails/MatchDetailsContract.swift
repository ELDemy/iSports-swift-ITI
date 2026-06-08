import Foundation

protocol MatchDetailsViewProtocol: AnyObject {
    func displayMatchInfo(_ event: Event)
    func displayStatistics(_ stats: [MatchStatistic])
    func displayLineups(home: [LineupPlayer], away: [LineupPlayer])
    func displayGoalscorers(_ scorers: [MatchGoalscorer])
    func displayCards(_ cards: [MatchCard])
    func showLoading()
    func hideLoading()
}

protocol MatchDetailsPresenterProtocol: AnyObject {
    var event: Event { get }
    func viewDidLoad()
}
