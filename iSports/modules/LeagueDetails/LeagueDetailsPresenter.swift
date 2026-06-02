import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    private weak var view: LeagueDetailsViewProtocol?
    private var isFavorite: Bool = false
    
    // Mock Data Arrays
    private var upcomingEvents: [Event] = []
    private var latestEvents: [LatestEvent] = []
    private var teams: [Team] = []
    
    init(view: LeagueDetailsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        // Mock Data with real team logo URLs from AllSportsAPI
        upcomingEvents = [
            Event(
                eventKey: 1, eventTime: "18:00", eventDate: "2026-06-15", eventDateStart: nil,
                eventFinalResult: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Real Madrid", eventAwayTeam: "Barcelona",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/players/5r6yt3_Vinicius-Junior_Logo.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/players/vbhv5-lamine-yamal.png",
                eventHomeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_leagues/3_premier-league.png",
                eventAwayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_leagues/302_la-liga.png",
                eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            ),
            Event(
                eventKey: 2, eventTime: "20:00", eventDate: "2026-06-16", eventDateStart: nil,
                eventFinalResult: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Arsenal", eventAwayTeam: "Chelsea",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/96_arsenal.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/94_chelsea.png",
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil,
                eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            ),
            Event(
                eventKey: 3, eventTime: "16:30", eventDate: "2026-06-17", eventDateStart: nil,
                eventFinalResult: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Juventus", eventAwayTeam: "AC Milan",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4187_juventus.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4184_ac-milan.png",
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil,
                eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            ),
            Event(
                eventKey: 4, eventTime: "21:45", eventDate: "2026-06-18", eventDateStart: nil,
                eventFinalResult: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "PSG", eventAwayTeam: "Lyon",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4131_paris-saint-germain.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4132_olympique-lyonnais.png",
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil,
                eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            )
        ]
        
        latestEvents = [
            LatestEvent(
                eventKey: 10, eventTime: "21:00", eventDate: "2026-06-01",
                eventHomeTeam: "Liverpool", eventAwayTeam: "Man City",
                eventHomeFinalResult: "3", eventAwayFinalResult: "1",
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/80_liverpool.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/82_manchester-city.png"
            ),
            LatestEvent(
                eventKey: 11, eventTime: "19:00", eventDate: "2026-05-28",
                eventHomeTeam: "Bayern Munich", eventAwayTeam: "Dortmund",
                eventHomeFinalResult: "2", eventAwayFinalResult: "0",
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/2672_bayern-munich.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/2673_borussia-dortmund.png"
            ),
            LatestEvent(
                eventKey: 12, eventTime: "20:45", eventDate: "2026-05-25",
                eventHomeTeam: "Inter Milan", eventAwayTeam: "Napoli",
                eventHomeFinalResult: "1", eventAwayFinalResult: "1",
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4186_inter-milan.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4199_napoli.png"
            ),
            LatestEvent(
                eventKey: 13, eventTime: "17:30", eventDate: "2026-05-22",
                eventHomeTeam: "Tottenham", eventAwayTeam: "Man Utd",
                eventHomeFinalResult: "0", eventAwayFinalResult: "2",
                homeTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/92_tottenham-hotspur.png",
                awayTeamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/78_manchester-united.png"
            )
        ]
        
        teams = [
            Team(teamKey: 1, teamName: "Real Madrid",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/7925_real-madrid.png"),
            Team(teamKey: 2, teamName: "Barcelona",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/7926_barcelona.png"),
            Team(teamKey: 3, teamName: "Arsenal",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/96_arsenal.png"),
            Team(teamKey: 4, teamName: "Chelsea",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/94_chelsea.png"),
            Team(teamKey: 5, teamName: "Liverpool",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/80_liverpool.png"),
            Team(teamKey: 6, teamName: "Man City",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/82_manchester-city.png"),
            Team(teamKey: 7, teamName: "Bayern",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/2672_bayern-munich.png"),
            Team(teamKey: 8, teamName: "Juventus",
                 teamLogo: "https://apiv2.allsportsapi.com/logo/logo_teams/4187_juventus.png")
        ]
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            self.view?.displayData(upcoming: self.upcomingEvents, latest: self.latestEvents, teams: self.teams)
            self.view?.toggleFavoriteState(isFavorite: self.isFavorite)
        }
    }
    
    func didTapFavorite() {
        isFavorite.toggle()
        view?.toggleFavoriteState(isFavorite: isFavorite)
    }
    
    func didSelectTeam(at index: Int) {
        print("Selected team: \(teams[index].teamName ?? "Unknown")")
    }
}
