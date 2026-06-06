import Foundation

struct PositionSection {
    let title: String
    let players: [PlayerModel]
}

protocol TeamDetailsViewProtocol: AnyObject {
    func displayTeamInfo(teamName: String?, logoUrl: String?)
    func reloadData()
}

class TeamDetailsPresenter {
    private weak var view: TeamDetailsViewProtocol?
    private var team: Team?
    
    private(set) var sections: [PositionSection] = []
    
    init(view: TeamDetailsViewProtocol, team: Team?) {
        self.view = view
        self.team = team
    }
    
    func viewDidLoad() {
        view?.displayTeamInfo(teamName: team?.teamName, logoUrl: team?.teamLogo)
        loadPlayers()
    }
    
    private func loadPlayers() {
        let allPlayers = team != nil ? (team?.players ?? []) : PlayerMockData.getAllPlayers()
        
        let goalkeepers = allPlayers.filter { $0.playerType == "Goalkeepers" }
        let defenders = allPlayers.filter { $0.playerType == "Defenders" }
        let midfielders = allPlayers.filter { $0.playerType == "Midfielders" }
        let forwards = allPlayers.filter { $0.playerType == "Forwards" }
        
        sections = []
        if !goalkeepers.isEmpty { sections.append(PositionSection(title: "GOALKEEPERS", players: goalkeepers)) }
        if !defenders.isEmpty { sections.append(PositionSection(title: "DEFENDERS", players: defenders)) }
        if !midfielders.isEmpty { sections.append(PositionSection(title: "MIDFIELDERS", players: midfielders)) }
        if !forwards.isEmpty { sections.append(PositionSection(title: "FORWARDS", players: forwards)) }
        
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
