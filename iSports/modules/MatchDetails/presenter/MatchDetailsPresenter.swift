import Foundation

class MatchDetailsPresenter: MatchDetailsPresenterProtocol {
    
    weak var view: MatchDetailsViewProtocol?
    let event: Event
    
    init(view: MatchDetailsViewProtocol, event: Event) {
        self.view = view
        self.event = event
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            self.view?.displayMatchInfo(self.event)
            
            if let stats = self.event.statistics {
                self.view?.displayStatistics(stats)
            }
            
            if let homeStarting = self.event.lineups?.home_team?.starting_lineups,
               let awayStarting = self.event.lineups?.away_team?.starting_lineups {
                self.view?.displayLineups(home: homeStarting, away: awayStarting)
            }
            
            if let scorers = self.event.goalscorers {
                self.view?.displayGoalscorers(scorers)
            }
            
            if let cards = self.event.cards {
                self.view?.displayCards(cards)
            }
            
            self.view?.hideLoading()
        }
    }
}
