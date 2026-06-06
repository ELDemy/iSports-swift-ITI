import Foundation


protocol LeagueDetailsPresenterProtocol: AnyObject {
    var leagueId: Int { get set }
    var sportName: String { get set }
    func viewDidLoad()
    func didTapFavorite()
    func didSelectTeam(at index: Int)
}


class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {

    // MARK: - Protocol Properties
    var leagueId: Int
    var sportName: String

    // MARK: - Private
    private weak var view: LeagueDetailsViewProtocol?
    private let network: NetworkService

    private var isFavorite: Bool = false

    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []

    // MARK: - Init
    init(view: LeagueDetailsViewProtocol,
         leagueId: Int = 766,
         sportName: String = "basketball",
         network: NetworkService = AlamofireManager.shared) {
        self.view = view
        self.leagueId = leagueId
        self.sportName = sportName
        self.network = network
    }

    // MARK: - LeagueDetailsPresenterProtocol
    func viewDidLoad() {
        view?.showLoading()
        fetchLeagueData()
    }

    func didTapFavorite() {
        isFavorite.toggle()
        view?.toggleFavoriteState(isFavorite: isFavorite)
    }

    func didSelectTeam(at index: Int) {
        guard index < teams.count else { return }
        print("Selected team: \(teams[index].teamName ?? "Unknown")")
    }

    // MARK: - Networking
    private func fetchLeagueData() {
        let group = DispatchGroup()

        var fetchedEvents: [Event] = []
        var fetchedTeams: [Team] = []
        var fetchError: Error?

        // --- Date range: past 30 days → next 60 days ---
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let fromDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: -30, to: today)!)
        let toDate   = formatter.string(from: Calendar.current.date(byAdding: .day, value: 60,  to: today)!)

        // 1. Fetch fixtures (used for both upcoming & latest)
        group.enter()
        network.getEvents(sportName: sportName,
                          from: fromDate,
                          to: toDate,
                          leagueId: leagueId) { result in
            switch result {
            case .success(let events):
                fetchedEvents = events
            case .failure(let error):
                fetchError = error
                print("getEvents error: \(error)")
            }
            group.leave()
        }

        // 2. Fetch teams / participants
        group.enter()
        if sportName.lowercased() != "tennis" {
            network.getTeams(sportName: sportName, leagueId: leagueId) { result in
                switch result {
                case .success(let teams):
                    fetchedTeams = teams
                case .failure(let error):
                    fetchError = error
                    print("getTeams error: \(error)")
                }
                group.leave()
            }
        } else {
            // Tennis / Basketball — participants are players
            network.getParticipants(sportName: sportName,
                                    method: "Players",
                                    leagueId: leagueId) { result in
                switch result {
                case .success(let participants):
                    // Map Participant → Team (reuse Team model as a generic "participant" card)
                    fetchedTeams = participants.map {
                        Team(teamKey: $0.key, teamName: $0.name, teamLogo: $0.logo, players: nil)
                    }
                case .failure(let error):
                    fetchError = error
                    print("getParticipants error: \(error)")
                }
                group.leave()
            }
        }

        // When both requests finish, update the view
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            self.view?.hideLoading()

            if let error = fetchError, fetchedEvents.isEmpty && fetchedTeams.isEmpty {
                self.view?.displayError(error.localizedDescription)
                return
            }

            // Split fixtures by whether they have a final result
            let upcoming = fetchedEvents.filter { event in
                let result = event.eventFinalResult ?? ""
                return result.isEmpty || result == "-"
            }

            
            let latest: [Event] = fetchedEvents
                .filter { event in
                    print("event.eventFinalResult \(event.eventFinalResult)")
                    print("event.eventHomeFinalResult \(event.eventHomeFinalResult)")
                    print("event.eventAwayFinalResult \(event.eventAwayFinalResult)")

                    let result = event.eventFinalResult ?? ""
                    return !result.isEmpty && result != "-"
                }

            self.upcomingEvents = upcoming
            self.latestEvents   = latest
            self.teams          = fetchedTeams

            self.view?.displayData(
                upcoming: self.upcomingEvents,
                latest:   self.latestEvents,
                teams:    self.teams
            )
            self.view?.toggleFavoriteState(isFavorite: self.isFavorite)
        }
    }
}
