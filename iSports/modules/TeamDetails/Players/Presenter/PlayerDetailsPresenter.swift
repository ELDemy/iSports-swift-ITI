import Foundation

protocol PlayerDetailsViewProtocol: AnyObject {
    func displayPlayerDetails(player: PlayerModel?, imageUrl: String?)
    func displayPlayerStats(stats: [(iconName: String, title: String, value: String)])
    func showLoading()
    func hideLoading()
}

class PlayerDetailsPresenter {
    private weak var view: PlayerDetailsViewProtocol?
    private var player: PlayerModel?
    
    init(view: PlayerDetailsViewProtocol, player: PlayerModel?) {
        self.view = view
        self.player = player
    }
    
    func viewDidLoad() {
        guard let player = player else { return }
        
        let name = player.playerName ?? "Unknown"
        let position = player.playerType?.uppercased() ?? "UNKNOWN POSITION"
        let imageUrl = player.playerImage
        
       // view?.displayPlayerDetails(name: name, position: position, imageUrl: imageUrl)
        view?.displayPlayerDetails(player:player, imageUrl: imageUrl)
        
        let age = player.playerAge ?? "N/A"
        let number = player.playerNumber ?? "-"
        let matches = player.playerMatchPlayed ?? "0"
        let goals = (player.playerGoals == nil || player.playerGoals == "") ? "0" : player.playerGoals!
        let rating = player.playerRating ?? "N/A"
        
        let stats: [(iconName: String, title: String, value: String)] = [
            ("person.text.rectangle", "Age", age),
            ("number.circle", "Squad Number", number),
            ("sportscourt", "Matches Played", matches),
            ("soccerball", "Goals", goals),
            ("star.circle", "Rating", rating)
        ]
        
        view?.displayPlayerStats(stats: stats)
    }
}
