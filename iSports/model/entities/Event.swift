//
//  Event.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import Foundation

struct Event: Decodable {
    let eventKey: Int?
    let eventTime: String?
    
    let eventDate: String?
    let eventDateStart: String?
    
    let eventFinalResult: String?
    let eventHomeFinalResult: String?
    let eventAwayFinalResult: String?
    
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let eventFirstPlayer: String?
    let eventSecondPlayer: String?
    
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventHomeTeamLogo: String?
    let eventAwayTeamLogo: String?
    let eventFirstPlayerLogo: String?
    let eventSecondPlayerLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventTime = "event_time"
        
        case eventDate = "event_date"
        case eventDateStart = "event_date_start"
        
        case eventFinalResult = "event_final_result"
        case eventHomeFinalResult = "event_home_final_result"
        case eventAwayFinalResult = "event_away_final_result"
        
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventFirstPlayer = "event_first_player"
        case eventSecondPlayer = "event_second_player"
        
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventHomeTeamLogo = "event_home_team_logo"
        case eventAwayTeamLogo = "event_away_team_logo"
        case eventFirstPlayerLogo = "event_first_player_logo"
        case eventSecondPlayerLogo = "event_second_player_logo"
    }
    
    
    var displayHomeName: String? {
        return eventHomeTeam ?? eventFirstPlayer
    }
    
    var displayAwayName: String? {
        return eventAwayTeam ?? eventSecondPlayer
    }
    
    var displayHomeLogo: String? {
        return homeTeamLogo ?? eventHomeTeamLogo ?? eventFirstPlayerLogo
    }
    
    var displayAwayLogo: String? {
        return awayTeamLogo ?? eventAwayTeamLogo ?? eventSecondPlayerLogo
    }
    
    var displayDate: String? {
        return eventDate ?? eventDateStart
    }
    
    var displayResult: String? {
        if let combined = eventFinalResult, !combined.isEmpty, combined != "-" {
            return combined
        }
        
        if let homeScore = eventHomeFinalResult, let awayScore = eventAwayFinalResult, !homeScore.isEmpty {
            return "\(homeScore) - \(awayScore)"
        }
        
        return "VS"
    }
}

struct EventResponse: Decodable {
    let result: [Event]?
}
