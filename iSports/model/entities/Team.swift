//
//  Team.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import Foundation

struct Team: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    let players: [PlayerModel]?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players
    }
}

struct TeamResponse: Codable {
    let success: Int?
    let result: [Team]?
}

