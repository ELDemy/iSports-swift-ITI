import Foundation

struct LatestEvent: Decodable {
    let eventKey: Int?
    let eventTime: String?
    let eventDate: String?
    
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    
    let eventHomeFinalResult: String?
    let eventAwayFinalResult: String?
    
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    
    var displayHomeName: String? { return eventHomeTeam }
    var displayAwayName: String? { return eventAwayTeam }
    
    var displayResult: String? {
        if let homeScore = eventHomeFinalResult, let awayScore = eventAwayFinalResult, !homeScore.isEmpty {
            return "\(homeScore) - \(awayScore)"
        }
        return "VS"
    }
}
