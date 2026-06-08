//
//  FavPresenter.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//

import Foundation



protocol FavView: AnyObject {
    func showFavorites()
    func showEmptyState()
}

class FavPresenter {
    weak var view: FavView?
    var sport : String
    private weak var router: AppRouterProtocol?
    var groupedLeagues: [String: [Leagues]] = [:]
    var sports: [String] = []
    
    init(view: FavView, router: AppRouterProtocol, sportName: String) {
        self.view = view
        self.router = router
        self.sport = sportName
    }
    
    func fetchFavorites() {
        let allLeagues = CoreDataManager.shared.fetchLeague()
        groupedLeagues = Dictionary(grouping: allLeagues, by: { $0.sportName?.capitalized ?? "Other" })
        sports = groupedLeagues.keys.sorted()
        
        DispatchQueue.main.async { [weak self] in
            if allLeagues.isEmpty {
                self?.view?.showEmptyState()
            } else {
                self?.view?.showFavorites()
            }
        }
    }
    
    func getNumberOfSections() -> Int {
        return sports.count
    }
    
    func getSportName(for section: Int) -> String {
        return sports[section]
    }
    
    func getCount(in section: Int) -> Int {
        let sport = sports[section]
        return groupedLeagues[sport]?.count ?? 0
    }
    
    func getLeague(at indexPath: IndexPath) -> Leagues {
        let sport = sports[indexPath.section]
        return groupedLeagues[sport]![indexPath.row]
    }
    
    func removeFavorite(at indexPath: IndexPath) {
        SoundManager.shared.playSound(Constants.Sounds.remove)
        let sport = sports[indexPath.section]
        if let league = groupedLeagues[sport]?[indexPath.row] {
            CoreDataManager.shared.deleteLeague(league: league)
        }
        
        fetchFavorites()
    }
    
    func didSelectLeague(at indexPath: IndexPath) {
        let sportName = sports[indexPath.section]
        guard let coreDataLeague = groupedLeagues[sportName]?[indexPath.row] else { return }
        
        let name = coreDataLeague.leagueName ?? NSLocalizedString("UNKNOWN_LEAGUE", comment: "")
        let savedSport = coreDataLeague.sportName ?? "football"
        let id = Int(coreDataLeague.leagueId)
        
        let savedLogoUrl = coreDataLeague.leagueLogo
        
        let model = LeagueModel(leagueKey: id, leagueName: name, leagueLogo: savedLogoUrl, countryName: sportName)
        
        router?.navigateToLeagueDetails(sportName: savedSport, league: model)
    }
}
