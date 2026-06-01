//
//  Team.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import Foundation

struct Team: Decodable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}

struct TeamResponse: Decodable {
    let result: [Team]?
}
