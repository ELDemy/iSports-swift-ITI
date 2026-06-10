import Foundation

// MARK: - Sport Category Helper
private enum SportCategory {
    case teamBased
    case playerBased

    init(sportName: String) {
        switch sportName.lowercased() {
        case "tennis":
            self = .playerBased
        default:
            self = .teamBased
        }
    }
}

// MARK: - Presenter Protocol
protocol LeagueDetailsPresenterProtocol: AnyObject {
    var league: LeagueModel { get set }
    var sportName: String { get set }
    var appRouter: AppRouter? { get set }
    func viewDidLoad()
    func checkIsFavorite() -> Bool
    func didTapFavorite()
    func didSelectTeam(team: Team)->Bool
    func didSelectEvent(event: Event)
}

// MARK: - LeagueDetailsPresenter
class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {

    // MARK: - Protocol Properties
    var league: LeagueModel
    var sportName:  String
    var appRouter:  AppRouter?

    // MARK: - Private
    private weak var view:     LeagueDetailsViewProtocol?
    private let      network:  NetworkService
    private var      isFavorite: Bool = false

    private var upcomingEvents: [Event] = []
    private var latestEvents:   [Event] = []
    private var teams:          [Team]  = []

    // MARK: - Init
    init(view:       LeagueDetailsViewProtocol,
         appRouter:  AppRouter?,
         league:     LeagueModel,
         sportName:  String        = "basketball",
         network:    NetworkService = AlamofireManager.shared) {
        self.view       = view
        self.league     = league
        self.sportName  = sportName
        self.network    = network
        self.appRouter  = appRouter
        
       isFavorite = checkIsFavorite()
    }

    // MARK: - LeagueDetailsPresenterProtocol
    func viewDidLoad() {
        view?.showLoading()
        view?.setLeagueName(league.leagueName!, sportName: sportName)
        fetchLeagueData()
    }

    func checkIsFavorite() -> Bool {
        let id = Int16(league.leagueKey!)
        return CoreDataManager.shared.isFavorite(id: id) != nil
    }
    
    func didTapFavorite() {
        SoundManager.shared.playSound(Constants.Sounds.fav)
        
        CoreDataManager.shared.toggleLeagueFavoriteStatus(apiLeague: league, sportName: self.sportName)
        
        isFavorite.toggle()
        view?.toggleFavoriteState(isFavorite: isFavorite)
    }

    func didSelectTeam(team: Team) -> Bool {
      
        if sportName == "basketball" || sportName == "cricket" {
            return false
        }
        
        if sportName == "tennis" {
            appRouter?.navigateToPlayerDetails(team: team, sportName: sportName)
        } else {
            appRouter?.navigateToTeamDetails(team: team, sportName: sportName)
        }
        return true;
    }
    
    func didSelectEvent(event: Event) {
        appRouter?.navigateToMatchDetails(event: event)
    }

    // MARK: - Private – Networking
    private func fetchLeagueData() {
        let group = DispatchGroup()
        var fetchedEvents: [Event] = []
        var fetchedTeams:  [Team]  = []
        var fetchError:    Error?

        let (fromDate, toDate) = makeDateRange(pastDays: 45, futureDays: 7)

        group.enter()
        network.getEvents(sportName: sportName,
                          from: fromDate,
                          to: toDate,
                          leagueId: league.leagueKey!) { result in
            switch result {
            case .success(let events): fetchedEvents = events
            case .failure(let error):
                fetchError = error
                print("getEvents error:", error)
            }
            group.leave()
        }

        group.enter()
        fetchParticipants { result in
            switch result {
            case .success(let t): fetchedTeams = t
            case .failure(let e):
                fetchError = e
                print("fetchParticipants error:", e)
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.view?.hideLoading()

            if let error = fetchError, fetchedEvents.isEmpty, fetchedTeams.isEmpty {
                self.view?.displayError(error.localizedDescription)
                return
            }

            self.processAndDisplay(events: fetchedEvents, teams: fetchedTeams)
        }
    }

    private func makeDateRange(pastDays: Int, futureDays: Int) -> (from: String, to: String) {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            fmt.locale = Locale(identifier: "en_US_POSIX")
            
            let today = Date()
            let from  = fmt.string(from: Calendar.current.date(byAdding: .day, value: -pastDays, to: today)!)
            let to    = fmt.string(from: Calendar.current.date(byAdding: .day, value:  futureDays, to: today)!)
            return (from, to)
        }

    private func fetchParticipants(completion: @escaping (Result<[Team], Error>) -> Void) {
        switch SportCategory(sportName: sportName) {
        case .teamBased:
            network.getTeams(sportName: sportName, leagueId: league.leagueKey!, completion: completion)
        case .playerBased:
            network.getParticipants(sportName: sportName,
                                    method: "Players",
                                    leagueId: league.leagueKey!) { result in
                switch result {
                case .success(let participants):
                    let teams = participants.map {
                        Team(teamKey: $0.key, teamName: $0.name, teamLogo: $0.logo, players: nil)
                    }
                    completion(.success(teams))
                case .failure(let e):
                    completion(.failure(e))
                }
            }
        }
    }

    private func processAndDisplay(events: [Event], teams: [Team]) {
        let dateParser = makeDateParser()

        upcomingEvents = events
            .filter { isUpcoming($0) }
            .sorted { lhs, rhs in
                let l = dateParser(lhs.displayDate ?? ""), r = dateParser(rhs.displayDate ?? "")
                return (l ?? .distantFuture) < (r ?? .distantFuture)
            }

        latestEvents = events
            .filter { !isUpcoming($0) }
            .sorted { lhs, rhs in
                let l = dateParser(lhs.displayDate ?? ""), r = dateParser(rhs.displayDate ?? "")
                return (l ?? .distantPast) > (r ?? .distantPast)
            }

        self.teams = teams

        view?.displayData(
            upcoming: upcomingEvents,
            latest:   latestEvents,
            teams:    self.teams
        )
        view?.toggleFavoriteState(isFavorite: isFavorite)
    }

    private func isUpcoming(_ event: Event) -> Bool {
        let result = event.eventFinalResult ?? ""
        return result.isEmpty || result == "-"
    }

    private func makeDateParser() -> (String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return { fmt.date(from: $0) }
    }
}
