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
    }
}
