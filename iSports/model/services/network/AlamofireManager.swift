//
//  AlamofireManager.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//

import Foundation
import Alamofire

class AlamofireManager: NetworkService {

    static let shared = AlamofireManager()
    private init() {}
    
    private let apiKey = "78a47459f1ca436ad990b04354657bbde03363b5283d2d21e12aa2b23700f248"
    
    func getLeagues(sportName: String, completion: @escaping (Result<[LeagueModel], Error>) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Leagues&APIkey=\(apiKey)"
        
        AF.request(url).responseDecodable(of: LeagueResponse.self) { response in
           switch response.result {
           case .success(let data):
               completion(.success(data.result ?? []))
           case .failure(let error):
               print("getLeagues error: \(error)")
               completion(.failure(error))
            }
        }
    }
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping (Result<[Event], Error>) -> Void) {
        var url = "\(Constants.API.baseURL)/\(sportName)?met=Fixtures&APIkey=\(apiKey)&from=\(from)&to=\(to)&timezone=Africa/Cairo"
        
        if let id = leagueId {
            url += "&leagueId=\(id)"
        }
        
        AF.request(url).responseDecodable(of: EventResponse.self) { response in
           switch response.result {
           case .success(let data):
               completion(.success(data.result ?? []))
           case .failure(let error):
               print("getEvents error: \(error)")
               completion(.failure(error))
            }
        }
    }
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping (Result<[Participant], Error>) -> Void) {
        var url = "\(Constants.API.baseURL)/\(sportName)?met=\(method)&APIkey=\(apiKey)"
        
        if let id = leagueId {
            url += "&leagueId=\(id)"
        }
        
        AF.request(url).responseDecodable(of: ParticipantResponse.self) { response in
           switch response.result {
           case .success(let data):
               completion(.success(data.result ?? []))
           case .failure(let error):
               print("getParticipants error: \(error)")
               completion(.failure(error))
            }
        }
    }
    
    func getTeams(sportName: String, leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Teams&APIkey=\(apiKey)&leagueId=\(leagueId)"
        
        AF.request(url).responseDecodable(of: TeamResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.result ?? []))
            case .failure(let error):
                print("getTeams error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping (Result<[PlayerModel], Error>) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Players&APIkey=\(apiKey)&teamId=\(teamId)"
        
        AF.request(url).responseDecodable(of: PlayerResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.result ?? []))
            case .failure(let error):
                print("getRoster error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

