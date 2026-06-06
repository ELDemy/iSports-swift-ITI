import Foundation

class MatchDetailsPresenter: MatchDetailsPresenterProtocol {
    
    weak var view: MatchDetailsViewProtocol?
    let event: Event
    
    init(view: MatchDetailsViewProtocol, event: Event) {
        self.view = view
        self.event = event
    }
    
    func viewDidLoad() {
        view?.displayMatchInfo(event)
        
        if let stats = event.statistics {
            view?.displayStatistics(stats)
        }
        
        if let homeStarting = event.lineups?.home_team?.starting_lineups,
           let awayStarting = event.lineups?.away_team?.starting_lineups {
            view?.displayLineups(home: homeStarting, away: awayStarting)
        }
        
        if let scorers = event.goalscorers {
            view?.displayGoalscorers(scorers)
        }
        
        if let cards = event.cards {
            view?.displayCards(cards)
        }
    }
}
