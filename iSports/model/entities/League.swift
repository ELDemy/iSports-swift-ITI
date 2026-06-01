//
//  League.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import Foundation

struct LeagueModel: Decodable {
    let leagueKey: Int?
    let leagueName: String?
    let leagueLogo: String?
    let countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case countryName = "country_name"
    }
}

struct LeagueResponse: Decodable {
    let result: [LeagueModel]?
}
