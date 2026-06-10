import UIKit

protocol AppRouterProtocol: AnyObject {
    func navigateToLeagueDetails(sportName: String, league: LeagueModel)
    func navigateToMatchDetails(event: Event)
    func navigateToTeamDetails(team: Team, sportName: String)
    func navigateToPlayerDetails(team: Team, sportName: String)
    func navigateToLeagues(for sport: String)

}

class AppRouter: AppRouterProtocol {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    private func performIfConnected(action: @escaping () -> Void) {
        if NetworkMonitor.shared.isConnected {
            action()
        } else {
            navigationController.topViewController?.showNoInternetAlert()
        }
    }

    
    func navigateToLeagues(for sport: String) {
        performIfConnected { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            guard let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else {
                print("DEBUG: Could not instantiate LeaguesViewController")
                return
            }
            
            vc.presenter = LeaguePresenter(view: vc, sportName: sport, router: self)
            navigationController.pushViewController(vc, animated: true)
        }
    }

 
    func navigateToMatchDetails(event: Event) {
        performIfConnected { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard
                let matchVC = storyboard.instantiateViewController(
                    withIdentifier: "MatchDetailsViewController"
                ) as? MatchDetailsViewController
            else { return }

            matchVC.presenter = MatchDetailsPresenter(
                view: matchVC,
                event: event
            )
            self.navigationController.pushViewController(
                matchVC,
                animated: true
            )
        }
    }

    func navigateToTeamDetails(team: Team, sportName: String) {
        performIfConnected { [weak self] in
            guard let self = self else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard
                let teamVC = storyboard.instantiateViewController(
                    withIdentifier: "TeamDetailsViewController"
                ) as? TeamDetailsViewController
            else { return }

            teamVC.team = team
            teamVC.sportName = sportName
            self.navigationController.pushViewController(teamVC, animated: true)
        }
    }

    func navigateToPlayerDetails(team: Team, sportName: String) {
        performIfConnected { [weak self] in
            guard let self = self else { return }
            let player = PlayerModel(
                playerKey: team.teamKey,
                playerName: team.teamName,
                playerNumber: nil,
                playerCountry: nil,
                playerType: nil,
                playerAge: nil,
                playerImage: team.teamLogo,
                playerLogo: team.teamLogo,
                teamName: nil,
                teamKey: nil,
                playerMinutes: nil,
                playerBirthdate: nil,
                playerIsCaptain: nil,
                playerMatchPlayed: nil,
                playerGoals: nil,
                playerRating: nil,
                playerBday: nil,
                stats: nil
            )
            let playerVC = PlayerDetailsViewController()
            playerVC.player = player
            playerVC.sportName = sportName

            self.navigationController.pushViewController(
                playerVC,
                animated: true
            )
        }
    }

    func navigateToLeagueDetails(sportName: String, league: LeagueModel) {
        performIfConnected { [weak self] in
            guard let self = self else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard
                let vc = storyboard.instantiateViewController(
                    withIdentifier: "LeagueDetailsViewController"
                ) as? LeagueDetailsViewController
            else { return }

            vc.league = league
            vc.sportName = sportName
            vc.presenter = LeagueDetailsPresenter(
                view: vc,
                appRouter: self,
                league: league,
                sportName: sportName
            )

            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}
