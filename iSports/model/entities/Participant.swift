//
//  Participant.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//


import Foundation

struct Participant: Decodable {
    let key: Int?
    let name: String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerLogo = "player_logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        

        self.key = try container.decodeIfPresent(Int.self, forKey: .teamKey) ?? container.decodeIfPresent(Int.self, forKey: .playerKey)
        self.name = try container.decodeIfPresent(String.self, forKey: .teamName) ?? container.decodeIfPresent(String.self, forKey: .playerName)
        self.logo = try container.decodeIfPresent(String.self, forKey: .teamLogo) ?? container.decodeIfPresent(String.self, forKey: .playerLogo)
    }
}

struct ParticipantResponse: Decodable {
    let result: [Participant]?
}
