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
    private var sportName: String?
    
    init(view: PlayerDetailsViewProtocol, player: PlayerModel?, sportName: String? = nil) {
        self.view = view
        self.player = player
        self.sportName = sportName
    }
    
    func viewDidLoad() {
        guard let player = player else { return }
        
        if let sport = sportName, sport.lowercased() == "tennis", let playerId = player.playerKey {
            view?.showLoading()
            AlamofireManager.shared.getPlayerDetails(sportName: sport, playerId: playerId) { [weak self] result in
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    switch result {
                    case .success(let detailedPlayer):
                        self?.player = detailedPlayer
                        self?.displayLoadedPlayer(detailedPlayer)
                    case .failure(let error):
                        print("Error loading tennis player details: \(error)")
                        self?.displayLoadedPlayer(player)
                    }
                }
            }
        } else {
            displayLoadedPlayer(player)
        }
    }
    
    private func displayLoadedPlayer(_ player: PlayerModel) {
        let imageUrl = player.playerImage ?? player.playerLogo
        view?.displayPlayerDetails(player: player, imageUrl: imageUrl)
        
        if let sport = sportName, sport.lowercased() == "tennis" {
            var stats: [(iconName: String, title: String, value: String)] = []
            
            if let bday = player.playerBday, !bday.isEmpty {
                stats.append(("calendar", L10n.playerBirthday.localized, bday))
            } else if let bday = player.playerBirthdate, !bday.isEmpty {
                stats.append(("calendar", L10n.playerBirthday.localized, bday))
            }
            
            if let country = player.playerCountry, !country.isEmpty {
                stats.append(("globe", L10n.playerCountry.localized, country))
            }
            
            if let latestStat = player.stats?.first {
                let rank = latestStat.rank ?? "-"
                let titles = latestStat.titles ?? "-"
                let won = latestStat.matchesWon ?? "-"
                let lost = latestStat.matchesLost ?? "-"
                
                stats.append(("sportscourt", String(format: L10n.playerRank.localized, latestStat.season ?? ""), rank))
                stats.append(("trophy.fill", L10n.playerTitles.localized, titles))
                stats.append(("checkmark.circle.fill", L10n.playerMatchesWon.localized, won))
                stats.append(("xmark.circle.fill", L10n.playerMatchesLost.localized, lost))
                
                if let clayW = latestStat.clayWon, let clayL = latestStat.clayLost, !clayW.isEmpty || !clayL.isEmpty {
                    stats.append(("circle.fill", L10n.playerClayWl.localized, "\(clayW)/\(clayL)"))
                }
                if let hardW = latestStat.hardWon, let hardL = latestStat.hardLost, !hardW.isEmpty || !hardL.isEmpty {
                    stats.append(("square.fill", L10n.playerHardWl.localized, "\(hardW)/\(hardL)"))
                }
                if let grassW = latestStat.grassWon, let grassL = latestStat.grassLost, !grassW.isEmpty || !grassL.isEmpty {
                    stats.append(("leaf.fill", L10n.playerGrassWl.localized, "\(grassW)/\(grassL)"))
                }
            } else {
                stats.append(("sportscourt", L10n.playerMatchesWon.localized, "0"))
                stats.append(("xmark.circle", L10n.playerMatchesLost.localized, "0"))
            }
            view?.displayPlayerStats(stats: stats)
        } else {
            let age = player.playerAge ?? "N/A"
            let number = player.playerNumber ?? "-"
            let matches = player.playerMatchPlayed ?? "0"
            let goals = (player.playerGoals == nil || player.playerGoals == "") ? "0" : player.playerGoals!
            let rating = player.playerRating ?? "N/A"
            
            let stats: [(iconName: String, title: String, value: String)] = [
                ("person.text.rectangle", L10n.playerAge.localized, age),
                ("number.circle", L10n.playerSquadNumber.localized, number),
                ("sportscourt", L10n.playerMatchesPlayed.localized, matches),
                ("soccerball", L10n.playerGoals.localized, goals),
                ("star.circle", L10n.playerRating.localized, rating)
            ]
            view?.displayPlayerStats(stats: stats)
        }
    }
}
