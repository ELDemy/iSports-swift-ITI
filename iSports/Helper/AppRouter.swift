import UIKit

protocol AppRouterProtocol: AnyObject {
    func navigateToLeagueDetails(sportName: String, league: LeagueModel)
}

class AppRouter: AppRouterProtocol {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
  
    func navigateToLeagueDetails(sportName: String, league: LeagueModel) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController else {
                            return
            }
            
            vc.sportName = sportName
            vc.leagueId = league.leagueKey ?? 0
            vc.leagueName = league.leagueName ?? "League Details"
            
            self.navigationController.pushViewController(vc, animated: true)
    }
}
