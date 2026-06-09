import Foundation

struct PositionSection {
    let title: String
    let players: [PlayerModel]
}

protocol TeamDetailsViewProtocol: AnyObject {
    func displayTeamInfo(teamName: String?, logoUrl: String?)
    func reloadData()
    func showLoading()
    func hideLoading()
}

class TeamDetailsPresenter {
    private weak var view: TeamDetailsViewProtocol?
    private var team: Team?
    private var sportName: String?
    
    private(set) var sections: [PositionSection] = []
    
    init(view: TeamDetailsViewProtocol, team: Team?, sportName: String?) {
        self.view = view
        self.team = team
        self.sportName = sportName
    }
    
    func viewDidLoad() {
        view?.displayTeamInfo(teamName: team?.teamName, logoUrl: team?.teamLogo)
        loadPlayers()
    }
    
    private func loadPlayers() {
        guard let sportName = sportName, let teamId = team?.teamKey else {
            self.processPlayers(self.team?.players ?? PlayerMockData.getAllPlayers())
            return
        }
        
        view?.showLoading()
        AlamofireManager.shared.getRoster(sportName: sportName, teamId: teamId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let players):
                    self?.processPlayers(players)
                case .failure(let error):
                    print("Error fetching roster: \(error)")
                    self?.processPlayers([])
                }
            }
        }
    }
    
    private func processPlayers(_ allPlayers: [PlayerModel]) {
        let goalkeepers = allPlayers.filter { $0.playerType == "Goalkeepers" }
        let defenders = allPlayers.filter { $0.playerType == "Defenders" }
        let midfielders = allPlayers.filter { $0.playerType == "Midfielders" }
        let forwards = allPlayers.filter { $0.playerType == "Forwards" }
        
        var newSections: [PositionSection] = []
        if !goalkeepers.isEmpty { newSections.append(PositionSection(title: "GOALKEEPERS", players: goalkeepers)) }
        if !defenders.isEmpty { newSections.append(PositionSection(title: "DEFENDERS", players: defenders)) }
        if !midfielders.isEmpty { newSections.append(PositionSection(title: "MIDFIELDERS", players: midfielders)) }
        if !forwards.isEmpty { newSections.append(PositionSection(title: "FORWARDS", players: forwards)) }
        
        self.sections = newSections
        view?.reloadData()
    }
    
    var numberOfSections: Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sections[section].players.count
    }
    
    func player(at indexPath: IndexPath) -> PlayerModel {
        return sections[indexPath.section].players[indexPath.row]
    }
    
    func titleForSection(_ section: Int) -> String {
        return sections[section].title
    }
}
