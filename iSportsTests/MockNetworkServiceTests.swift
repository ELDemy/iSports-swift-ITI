//
//  MockNetworkServiceTests.swift
//  iSports
//
//  Created by ELDemy on 10/06/2026.
//

import XCTest

@testable import iSports

final class MockNetworkServiceTests: XCTestCase {

    var mockSuccessObj: MockNetworkService!
    var mockFailureObj: MockNetworkService!

    override func setUpWithError() throws {
        mockSuccessObj = MockNetworkService(shouldReturnWithError: false)
        mockFailureObj = MockNetworkService(shouldReturnWithError: true)
    }

    override func tearDownWithError() throws {
        mockSuccessObj = nil
        mockFailureObj = nil
    }

    // MARK: - Leagues Mock Tests

    func testMockGetLeagues_Success_test() {
        let ex = expectation(description: "Mock Leagues Success")
        mockSuccessObj.getLeagues(sportName: "football") { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testMockGetLeagues_Failure() {
        let ex = expectation(description: "Mock Leagues Failure")
        mockFailureObj.getLeagues(sportName: "football") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "MockError")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    // MARK: - Events Mock Tests

    func testMockGetEvents_Success() {
        let ex = expectation(description: "Mock Events Success")
        mockSuccessObj.getEvents(
            sportName: "football",
            from: "2024-01-01",
            to: "2024-12-31",
            leagueId: 205
        ) { result in
            switch result {
            case .success(let events):
                XCTAssertNotNil(events)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testMockGetEvents_Failure() {
        let ex = expectation(description: "Mock Events Failure")
        mockFailureObj.getEvents(
            sportName: "football",
            from: "2024-01-01",
            to: "2024-12-31",
            leagueId: 205
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    // MARK: - Participants Mock Tests

    func testMockGetParticipants_Success() {
        let ex = expectation(description: "Mock Participants Success")
        mockSuccessObj.getParticipants(
            sportName: "football",
            method: "Teams",
            leagueId: 205
        ) { result in
            switch result {
            case .success(let participants):
                XCTAssertNotNil(participants)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testMockGetParticipants_Failure() {
        let ex = expectation(description: "Mock Participants Failure")
        mockFailureObj.getParticipants(
            sportName: "football",
            method: "Teams",
            leagueId: 205
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    // MARK: - Roster Mock Tests

    func testMockGetRoster_Success() {
        let ex = expectation(description: "Mock Roster Success")
        mockSuccessObj.getRoster(sportName: "football", teamId: 2611) {
            result in
            switch result {
            case .success(let players):
                XCTAssertNotNil(players)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testMockGetRoster_Failure() {
        let ex = expectation(description: "Mock Roster Failure")
        mockFailureObj.getRoster(sportName: "football", teamId: 2611) {
            result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    // MARK: - Teams Mock Tests

    func testMockGetTeams_Success() {
        let ex = expectation(description: "Mock Teams Success")
        mockSuccessObj.getTeams(sportName: "football", leagueId: 205) {
            result in
            switch result {
            case .success(let teams):
                XCTAssertNotNil(teams)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testMockGetTeams_Failure() {
        let ex = expectation(description: "Mock Teams Failure")
        mockFailureObj.getTeams(sportName: "football", leagueId: 205) {
            result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    // MARK: - Player Details Mock Tests

    func testMockGetPlayerDetails_Success() {
        let ex = expectation(description: "Mock Player Details Success")
        mockSuccessObj.getPlayerDetails(sportName: "football", playerId: 77) {
            result in
            switch result {
            case .success(let player):
                XCTAssertNotNil(player)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }

    func testMockGetPlayerDetails_Failure() {
        let ex = expectation(description: "Mock Player Details Failure")
        mockFailureObj.getPlayerDetails(sportName: "football", playerId: 77) {
            result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}
