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
    
    // Match Details
    let eventStatus: String?
    let eventStadium: String?
    let eventReferee: String?
    let leagueRound: String?
    let eventHalftimeResult: String?
    let eventFtResult: String?
    
    let statistics: [MatchStatistic]?
    let lineups: MatchLineups?
    let goalscorers: [MatchGoalscorer]?
    let cards: [MatchCard]?
    
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
        
        case eventStatus = "event_status"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case leagueRound = "league_round"
        case eventHalftimeResult = "event_halftime_result"
        case eventFtResult = "event_ft_result"
        
        case statistics, lineups, goalscorers, cards
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

// MARK: - Match Details Structs

struct MatchStatistic: Decodable {
    let type: String?
    let home: String?
    let away: String?
}

struct MatchCard: Decodable {
    let time: String?
    let home_fault: String?
    let card: String?
    let away_fault: String?
    let info: String?
    let info_time: String?
}

struct MatchGoalscorer: Decodable {
    let time: String?
    let home_scorer: String?
    let home_assist: String?
    let score: String?
    let away_scorer: String?
    let away_assist: String?
    let info: String?
    let info_time: String?
    
    enum CodingKeys: String, CodingKey {
        case time, score, info, info_time
        case home_scorer, home_assist
        case away_scorer, away_assist
    }
    
    // Custom decoding to avoid crashes when the API returns an empty array [] instead of ""
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try? container.decodeIfPresent(String.self, forKey: .time)
        score = try? container.decodeIfPresent(String.self, forKey: .score)
        info = try? container.decodeIfPresent(String.self, forKey: .info)
        info_time = try? container.decodeIfPresent(String.self, forKey: .info_time)
        
        home_scorer = try? container.decodeIfPresent(String.self, forKey: .home_scorer)
        away_scorer = try? container.decodeIfPresent(String.self, forKey: .away_scorer)
        home_assist = try? container.decodeIfPresent(String.self, forKey: .home_assist)
        away_assist = try? container.decodeIfPresent(String.self, forKey: .away_assist)
    }
}

struct MatchLineups: Decodable {
    let home_team: TeamLineup?
    let away_team: TeamLineup?
}

struct TeamLineup: Decodable {
    let starting_lineups: [LineupPlayer]?
    let substitutes: [LineupPlayer]?
}

struct LineupPlayer: Decodable {
    let player: String?
    let player_number: Int?
    let player_position: Int?
}

