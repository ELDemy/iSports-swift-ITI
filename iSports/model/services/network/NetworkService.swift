//
//  NetworkService.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//


import Foundation

protocol NetworkService {
    func getLeagues(sportName: String, completion: @escaping (Result<[LeagueModel], Error>) -> Void)
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping (Result<[Event], Error>) -> Void)
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping (Result<[Participant], Error>) -> Void)
    
    func getTeams(sportName: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping (Result<[PlayerModel], Error>) -> Void)
}
