
import Foundation

protocol LeaguesView: AnyObject {
    func showLeagues()
    func hideLoading()
}

class LeaguePresenter {

    weak var view: LeaguesView?
    var leagues: [LeagueModel] = []
    
    var filteredLeagues: [LeagueModel] = []
    var isSearching: Bool = false
    
    var sport: String
    private weak var router: AppRouterProtocol?

    init(view: LeaguesView, sportName: String, router: AppRouterProtocol) {
        self.view = view
        self.sport = sportName
        self.router = router
    }
    func fetchLeague() {
            AlamofireManager.shared.getLeagues(sportName: sport) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    switch result {
                    case .success(let leagues):
                        if leagues.isEmpty {
                            self.view?.hideLoading()
                        } else {
                            self.leagues = leagues
                            self.view?.showLeagues()
                        }
                    case .failure(let error):
                        print("Error fetching leagues: \(error.localizedDescription)")
                        self.view?.hideLoading()

                    }
                }
            }
        }
   
    func filterLeagues(searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredLeagues.removeAll()
        } else {
            isSearching = true
            filteredLeagues = leagues.filter { league in
                league.leagueName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        view?.showLeagues()
    }
    
    func getCount() -> Int {
        return isSearching ? filteredLeagues.count : leagues.count
    }
    
    func getLeague(at index: Int) -> LeagueModel {
        return isSearching ? filteredLeagues[index] : leagues[index]
    }
    
    func didSelectLeague(at index: Int) {
        let selectedLeague = getLeague(at: index)
        
        let dynamicSound = Constants.Sounds.getSound(for: self.sport)
        SoundManager.shared.playSound(dynamicSound)
        
        router?.navigateToLeagueDetails(sportName: self.sport, league: selectedLeague)
    }
    
    func isFavorite(at index: Int) -> Bool {
        let league = getLeague(at: index)
        let id = Int16(league.leagueKey ?? 0)
        return CoreDataManager.shared.isFavorite(id: id) != nil
    }

    func toggleFavorite(at index: Int) -> Bool {
        SoundManager.shared.playSound(Constants.Sounds.fav)
        let league = getLeague(at: index)
        
        let isFav = isFavorite(at: index)
        
    
        CoreDataManager.shared.toggleLeagueFavoriteStatus(apiLeague: league, sportName: self.sport)
        
        return !isFav
    }
}
