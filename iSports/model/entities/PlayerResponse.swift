//
//  Player.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//


struct PlayerResponse: Codable {
    let success: Int?
    let result: [PlayerModel]?
}

struct PlayerModel: Codable {
    let playerKey:       Int?
    let playerName:      String?
    let playerNumber:    String?
    let playerCountry:   String?
    let playerType:      String?
    let playerAge:       String?
    let playerImage:     String?
    let playerLogo :     String?
    let teamName:        String?
    let teamKey:         Int?
    let playerMinutes:   String?
    let playerBirthdate: String?
    let playerIsCaptain: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerRating: String?
    let playerBday: String?
    let stats: [TennisPlayerStat]?

    enum CodingKeys: String, CodingKey {
        case playerKey       = "player_key"
        case playerName      = "player_name"
        case playerNumber    = "player_number"
        case playerCountry   = "player_country"
        case playerType      = "player_type"
        case playerAge       = "player_age"
        case playerImage     = "player_image"
        case playerLogo      = "player_logo"
        case teamName        = "team_name"
        case teamKey         = "team_key"
        case playerMinutes   = "player_minutes"
        case playerBirthdate = "player_birthdate"
        case playerIsCaptain = "player_is_captain"
        case playerMatchPlayed = "player_match_played"
        case playerGoals = "player_goals"
        case playerRating = "player_rating"
        case playerBday = "player_bday"
        case stats = "stats"
    }
}

struct TennisPlayerStat: Codable {
    let season: String?
    let type: String?
    let rank: String?
    let titles: String?
    let matchesWon: String?
    let matchesLost: String?
    let hardWon: String?
    let hardLost: String?
    let clayWon: String?
    let clayLost: String?
    let grassWon: String?
    let grassLost: String?
    
    enum CodingKeys: String, CodingKey {
        case season, type, rank, titles
        case matchesWon = "matches_won"
        case matchesLost = "matches_lost"
        case hardWon = "hard_won"
        case hardLost = "hard_lost"
        case clayWon = "clay_won"
        case clayLost = "clay_lost"
        case grassWon = "grass_won"
        case grassLost = "grass_lost"
    }
}
