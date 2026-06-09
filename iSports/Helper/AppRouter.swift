import UIKit

protocol AppRouterProtocol: AnyObject {
    func navigateToLeagueDetails(sportName: String, league: LeagueModel)
    func navigateToMatchDetails(event: Event)
    func navigateToTeamDetails(team: Team, sportName: String)
    func navigateToPlayerDetails(team: Team, sportName: String)
}

class AppRouter: AppRouterProtocol {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateToLeagueDetails(sportName: String, league: LeagueModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: "LeagueDetailsViewController"
        ) as? LeagueDetailsViewController else { return }

        vc.league    = league
        vc.sportName = sportName
        vc.presenter = LeagueDetailsPresenter(view: vc, appRouter: self, league: league, sportName: sportName)

        navigationController.pushViewController(vc, animated: true)
    }

    func navigateToMatchDetails(event: Event) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let matchVC = storyboard.instantiateViewController(
            withIdentifier: "MatchDetailsViewController"
        ) as? MatchDetailsViewController else { return }

        matchVC.presenter = MatchDetailsPresenter(view: matchVC, event: event)
        navigationController.pushViewController(matchVC, animated: true)
    }

    func navigateToTeamDetails(team: Team, sportName: String) {
        let sport = sportName.lowercased()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let teamVC = storyboard.instantiateViewController(
            withIdentifier: "TeamDetailsViewController"
        ) as? TeamDetailsViewController else { return }

        teamVC.team      = team
        teamVC.sportName = sportName
        navigationController.pushViewController(teamVC, animated: true)
    }

    func navigateToPlayerDetails(team: Team, sportName: String) {
        let player = PlayerModel(
            playerKey:        team.teamKey,
            playerName:       team.teamName,
            playerNumber:     nil,
            playerCountry:    nil,
            playerType:       nil,
            playerAge:        nil,
            playerImage:      team.teamLogo,
            playerLogo:       team.teamLogo,
            teamName:         nil,
            teamKey:          nil,
            playerMinutes:    nil,
            playerBirthdate:  nil,
            playerIsCaptain:  nil,
            playerMatchPlayed: nil,
            playerGoals:      nil,
            playerRating:     nil,
            playerBday:       nil,
            stats:            nil
        )
        let playerVC        = PlayerDetailsViewController()
        playerVC.player     = player
        playerVC.sportName  = sportName
        
        navigationController.pushViewController(playerVC, animated: true)
    }
}
