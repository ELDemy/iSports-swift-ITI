//
//  MockNetworkService.swift
//  iSports
//
//  Created by ELDemy on 10/06/2026.
//

import XCTest
@testable import iSports

final class MockNetworkService : NetworkService {

    let shouldReturnWithError : Bool
    init(shouldReturnWithError: Bool) {
        self.shouldReturnWithError = shouldReturnWithError
    }
    
    func getLeagues(sportName: String, completion: @escaping (Result<[LeagueModel], any Error>) -> Void) {
        if shouldReturnWithError {
            let error = NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock Failure"])
            completion(.failure(error))
        }else{
            completion(.success([]))

        }
    }
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping (Result<[Event], any Error>) -> Void) {
        if shouldReturnWithError{
        let error = NSError(domain: "MockError", code: 404, userInfo: nil)
                    completion(.failure(error))
              
            } else {
                    completion(.success([]))
      }
    }
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping (Result<[Participant], any Error>) -> Void) {
        if shouldReturnWithError {
                    let error = NSError(domain: "MockError", code: 404, userInfo: nil)
                    completion(.failure(error))
                } else {
                    completion(.success([]))
                }
    }
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping (Result<[PlayerModel], any Error>) -> Void) {
        if shouldReturnWithError {
                    let error = NSError(domain: "MockError", code: 404, userInfo: nil)
                    completion(.failure(error))
                } else {
                    completion(.success([]))
                }
            }

    
    func getTeams(sportName: String, leagueId: Int, completion: @escaping (Result<[iSports.Team], any Error>) -> Void) {
        //
    }
    
    func getPlayerDetails(sportName: String, playerId: Int, completion: @escaping (Result<iSports.PlayerModel, any Error>) -> Void) {
        //
    }
}
