//
//  AlamofireManagerTests.swift
//  iSports
//
//  Created by ELDemy on 10/06/2026.
//

import XCTest
@testable import iSports

final class AlamofireManagerTests: XCTestCase {
    var almoFireObj: AlamofireManager!
    
    override func setUpWithError() throws {
        almoFireObj = AlamofireManager.shared
    }
    
    override func tearDownWithError() throws {
        almoFireObj = nil
    }
    
    // MARK: - Success Tests

    func testGetLeaguesFromApi() {
        let ex = expectation(description: "load leagues from api")
        almoFireObj.getLeagues(sportName: "football") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
                XCTAssertGreaterThanOrEqual(leagues.count, 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetEventsFromApi() {
        let ex = expectation(description: "load Events from api")
        almoFireObj.getEvents(sportName: "football", from: "2024-01-01", to: "2024-12-31", leagueId: 205) { result in
            switch result {
            case .success(let events):
                XCTAssertNotNil(events)
                XCTAssertGreaterThanOrEqual(events.count, 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 8)
    }
    
    func testGetParticipantsFromApi() {
        let ex = expectation(description: "load Participants from api")
        almoFireObj.getParticipants(sportName: "football", method: "Teams", leagueId: 205) { result in
            switch result {
            case .success(let participants):
                XCTAssertNotNil(participants)
                XCTAssertGreaterThanOrEqual(participants.count, 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func testGetTeamsFromApi() {
        let ex = expectation(description: "load Teams from api")
        almoFireObj.getTeams(sportName: "football", leagueId: 205) { result in
            switch result {
            case .success(let teams):
                XCTAssertNotNil(teams)
                XCTAssertGreaterThanOrEqual(teams.count, 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetRostersFromApi() {
        let ex = expectation(description: "load Rosters from api")
        almoFireObj.getRoster(sportName: "football", teamId: 2611) { result in
            switch result {
            case .success(let players):
                XCTAssertNotNil(players)
                XCTAssertGreaterThanOrEqual(players.count, 0)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetPlayerDetailsFromApi_Success() {
        let ex = expectation(description: "load Player Details successfully from api")
        almoFireObj.getPlayerDetails(sportName: "football", playerId: 102) { result in
            switch result {
            case .success(let player):
                XCTAssertNotNil(player)
            case .failure(let error):// If API returns empty list, it jumps to failure block which we also assert below
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    // MARK: - Failure Tests
            
    func testGetLeaguesFromApi_Failure() {
        let ex = expectation(description: "load leagues failure from api")
        almoFireObj.getLeagues(sportName: "invalid sport") { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid sport name")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetEventsFromApi_Failure() {
        let ex = expectation(description: "load Events failure from api")
        almoFireObj.getEvents(sportName: "invalid sport", from: "2024-01-01", to: "2024-12-31", leagueId: 205) { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid sport name")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetParticipantsFromApi_Failure() {
        let ex = expectation(description: "load Participants failure from api")
        almoFireObj.getParticipants(sportName: "invalid sport", method: "Teams", leagueId: 205) { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid sport name")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetTeamsFromApi_Failure() {
        let ex = expectation(description: "load teams failure from api")
        almoFireObj.getTeams(sportName: "invalid sport", leagueId: 99999) { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid sport name")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetRostersFromApi_Failure() {
        let ex = expectation(description: "load Rosters failure from api")
        almoFireObj.getRoster(sportName: "invalid sport", teamId: 2611) { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid sport name")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetPlayerDetailsFromApi_Failure() {
        let ex = expectation(description: "load Player Details failure from api")
        almoFireObj.getPlayerDetails(sportName: "invalid sport", playerId: 0) { result in
            switch result {
            case .success:
                XCTFail("Should fail with invalid sport parameters")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    // MARK: - Nil Parameter Tests
        
    func testGetEventsFromApi_NilLeagueId() {
        let ex = expectation(description: "load Events with nil league ID")
        almoFireObj.getEvents(sportName: "football", from: "2024-01-01", to: "2024-12-31", leagueId: nil) { result in
            switch result {
            case .success(let events):
                XCTAssertNotNil(events)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 8)
    }
    
    func testGetParticipantsFromApi_NilLeagueId() {
        let ex = expectation(description: "load Participants with nil league ID")
        almoFireObj.getParticipants(sportName: "football", method: "Teams", leagueId: nil) { result in
            switch result {
            case .success(let participants):
                XCTAssertNotNil(participants)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 8)
    }
}
