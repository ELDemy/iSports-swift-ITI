//
//  CoreDataManagerTests.swift
//  iSportsTests
//
//  Created by ELDemy on 10/06/2026.
//

import XCTest
@testable import iSports

final class CoreDataManagerTests: XCTestCase {
    
    var coreDataObj: CoreDataManager!
    
    override func setUpWithError() throws {
        super.setUp()
        coreDataObj = CoreDataManager.shared
        // Clear database before each test to ensure a clean slate
        clearDatabase()
    }
    
    override func tearDownWithError() throws {
        // Clear database after each test to leave no remnants behind
        clearDatabase()
        coreDataObj = nil
        super.tearDown()
    }
    
    // MARK: - Helper Method
    private func clearDatabase() {
        let fetchRequest = CoreDataManager.shared.fetchLeague()
        for item in fetchRequest {
            CoreDataManager.shared.contex.delete(item)
        }
        try? CoreDataManager.shared.contex.save()
    }
    
    // MARK: - Save and Fetch Tests
    
    func testSaveLeague_Success() {
        // Given
        let leagueId: Int16 = 101
        let name = "English Premier League"
        let logo = "epl_logo_url"
        let sport = "football"
        
        // When
        coreDataObj.saveLeague(id: leagueId, name: name, logo: logo, sportName: sport)
        let leagues = coreDataObj.fetchLeague()
        
        // Then
        XCTAssertEqual(leagues.count, 1, "Database should contain exactly 1 league after insertion")
        XCTAssertEqual(leagues.first?.leagueId, leagueId)
        XCTAssertEqual(leagues.first?.leagueName, name)
        XCTAssertEqual(leagues.first?.leagueLogo, logo)
        XCTAssertEqual(leagues.first?.sportName, sport)
    }
    
    func testSaveLeague_WithNilLogo() {
        // Given
        let leagueId: Int16 = 102
        let name = "La Liga"
        let logo: String? = nil
        let sport = "football"
        
        // When
        coreDataObj.saveLeague(id: leagueId, name: name, logo: logo, sportName: sport)
        let leagues = coreDataObj.fetchLeague()
        
        // Then
        XCTAssertEqual(leagues.count, 1)
        XCTAssertNil(leagues.first?.leagueLogo, "League logo should be nil")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteLeague_Success() {
        // Given
        coreDataObj.saveLeague(id: 50, name: "Serie A", logo: "serie_a_url", sportName: "football")
        let leaguesBeforeDelete = coreDataObj.fetchLeague()
        XCTAssertEqual(leaguesBeforeDelete.count, 1)
        
        guard let leagueToDelete = leaguesBeforeDelete.first else {
            XCTFail("League failed to save initial status.")
            return
        }
        
        // When
        coreDataObj.deleteLeague(league: leagueToDelete)
        let leaguesAfterDelete = coreDataObj.fetchLeague()
        
        // Then
        XCTAssertEqual(leaguesAfterDelete.count, 0, "Database should be empty after item deletion")
    }
    
    // MARK: - Is Favorite Tests
    
    func testIsFavorite_WhenLeagueExists() {
        // Given
        let targetId: Int16 = 205
        coreDataObj.saveLeague(id: targetId, name: "CAF Champions League", logo: "caf_url", sportName: "football")
        
        // When
        let result = coreDataObj.isFavorite(id: targetId)
        
        // Then
        XCTAssertNotNil(result, "Should find the league matching the target ID")
        XCTAssertEqual(result?.leagueId, targetId)
    }
    
    func testIsFavorite_WhenLeagueDoesNotExist() {
        // Given
        let nonExistentId: Int16 = 999
        
        // When
        let result = coreDataObj.isFavorite(id: nonExistentId)
        
        // Then
        XCTAssertNil(result, "Should return nil if the league ID is not present in CoreData")
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavorite_AddsLeagueWhenNotPresent() {
        // Given
        let id: Int16 = 301
        let name = "Bundesliga"
        
        // When - First toggle inserts item
        let isSaved = coreDataObj.toggleFavorite(id: id, name: name, logo: "b_url", sportName: "football")
        
        // Then
        XCTAssertTrue(isSaved, "toggleFavorite should return true when a league is saved")
        XCTAssertNotNil(coreDataObj.isFavorite(id: id))
    }
    
    func testToggleFavorite_RemovesLeagueWhenAlreadyPresent() {
        // Given
        let id: Int16 = 301
        coreDataObj.saveLeague(id: id, name: "Bundesliga", logo: "b_url", sportName: "football")
        
        // When - Second toggle deletes item
        let isSaved = coreDataObj.toggleFavorite(id: id, name: "Bundesliga", logo: "b_url", sportName: "football")
        
        // Then
        XCTAssertFalse(isSaved, "toggleFavorite should return false when a league is deleted")
        XCTAssertNil(coreDataObj.isFavorite(id: id))
    }
    
    // MARK: - API Struct Mapping Tests
    
    // MARK: - API Struct Mapping Tests
        
        func testToggleLeagueFavoriteStatus_WithValidLeagueModel() {
            // Given - Using the real iSports.LeagueModel struct
            let mockModel = LeagueModel(
                leagueKey: 401,
                leagueName: "Ligue 1",
                leagueLogo: "ligue1_url",
                countryName: "France"
            )
            
            // When
            coreDataObj.toggleLeagueFavoriteStatus(apiLeague: mockModel, sportName: "football")
            
            // Then
            let foundLeague = coreDataObj.isFavorite(id: 401)
            XCTAssertNotNil(foundLeague)
            XCTAssertEqual(foundLeague?.leagueName, "Ligue 1")
        }
        
        func testToggleLeagueFavoriteStatus_WithNilValues() {
            // Given - Testing edge cases with all nil values
            let mockModelWithNils = LeagueModel(
                leagueKey: nil,
                leagueName: nil,
                leagueLogo: nil,
                countryName: nil
            )
            
            // When
            coreDataObj.toggleLeagueFavoriteStatus(apiLeague: mockModelWithNils, sportName: "tennis")
            
            // Then
            // leagueKey nil gets safely converted to 0 inside your manager's implementation
            let foundLeague = coreDataObj.isFavorite(id: 0)
            XCTAssertNotNil(foundLeague)
            XCTAssertEqual(foundLeague?.sportName, "tennis")
        }
}

