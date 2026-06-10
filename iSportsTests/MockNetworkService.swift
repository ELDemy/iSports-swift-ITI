//
//  MockNetworkService.swift
//  iSports
//
//  Created by ELDemy on 10/06/2026.
//

import Foundation
@testable import iSports

final class MockNetworkService: NetworkService {

    let shouldReturnWithError: Bool
    
    init(shouldReturnWithError: Bool) {
        self.shouldReturnWithError = shouldReturnWithError
    }
    
    private var mockError: Error {
        return NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock Failure"])
    }
    
    func getLeagues(sportName: String, completion: @escaping (Result<[LeagueModel], Error>) -> Void) {
        if shouldReturnWithError {
            completion(.failure(mockError))
        } else {
            completion(.success([]))
        }
    }
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping (Result<[Event], Error>) -> Void) {
        if shouldReturnWithError {
            completion(.failure(mockError))
        } else {
            completion(.success([]))
        }
    }
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping (Result<[Participant], Error>) -> Void) {
        if shouldReturnWithError {
            completion(.failure(mockError))
        } else {
            completion(.success([]))
        }
    }
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping (Result<[PlayerModel], Error>) -> Void) {
        if shouldReturnWithError {
            completion(.failure(mockError))
        } else {
            completion(.success([]))
        }
    }

    func getTeams(sportName: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        if shouldReturnWithError {
            completion(.failure(mockError))
        } else {
            completion(.success([])) // Fixed: Returns empty array on success
        }
    }
    
    func getPlayerDetails(sportName: String, playerId: Int, completion: @escaping (Result<PlayerModel, Error>) -> Void) {
        if shouldReturnWithError {
            completion(.failure(mockError))
        } else {
            // Fixed: Returns a mock single player instance instead of an array
            let dummyPlayer = PlayerModel(
                playerKey: nil,
                playerName: nil,
                playerNumber: nil,
                playerCountry: nil,
                playerType: nil,
                playerAge: nil,
                playerImage: nil,
                playerLogo: nil,
                teamName: nil,
                teamKey: nil,
                playerMinutes: nil,
                playerBirthdate: nil,
                playerIsCaptain: nil,
                playerMatchPlayed: nil,
                playerGoals: nil,
                playerRating: nil,
                playerBday: nil,
                stats: nil
            )
            completion(.success(dummyPlayer))
        }
    }
}
