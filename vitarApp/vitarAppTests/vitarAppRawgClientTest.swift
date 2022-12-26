//
//  vitarAppRawgClientTest.swift
//  vitarAppTests
//
//  Created by Kerem Safa Dirican on 12.12.2022.
//

import XCTest

final class vitarAppRawgClientTest: XCTestCase {

    private var games:[RawgModel]?
    
    private var gameDetail: RawgDetailModel?
    
    private var gameSearchResult:[RawgModel]?
    
    
    //MARK: - Get Popular Tests
    func testGetPopularGames() throws {
        let fetchExpectation = expectation(description: "fetchPopularGames")
        //Given
        XCTAssertEqual(games?.count, nil)
        
        //When
        RawgClient.getPopularGames { [weak self] games, error in
            guard let self = self else { return }
            self.games = games
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertNotNil(games)
        
        if let games{
            XCTAssertGreaterThan(games.count, 2)
        }
        
    }
    
    //MARK: - Game Detail Tests
    func testGetGameDetail() throws {
        let fetchExpectation = expectation(description: "fetchGameDetail")
        
        //Given
        XCTAssertEqual(games?.count, nil)
        
        //When
        RawgClient.getGameDetail(gameId: 41494) { [weak self] gameDetail, error in
            guard let self = self else { return }
            self.gameDetail = gameDetail
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertEqual(gameDetail?.name, "Cyberpunk 2077")
        XCTAssertEqual(gameDetail?.rating?.name, "Mature")
        XCTAssertEqual(gameDetail?.parentPlatforms?[1].platform?.name, "PlayStation")
        XCTAssertEqual(gameDetail?.developers?[0].name, "CD PROJEKT RED")
        XCTAssertEqual(gameDetail?.genres?[2].name, "RPG")
        
    }
    
    func testGetGameDetailFail() throws {
        let fetchExpectation = expectation(description: "fetchGameDetail")
        
        //Given
        XCTAssertEqual(games?.count, nil)
        
        //When
        RawgClient.getGameDetail(gameId: 999999) { [weak self] gameDetail, error in
            guard let self = self else { return }
            self.gameDetail = gameDetail
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertNil(gameDetail?.id)
        
    }
    
    
    //MARK: - Search Game Tests
    func testSearchGame() throws {
        let fetchExpectation = expectation(description: "fetchGameSearch")
        
        //Given
        XCTAssertEqual(gameSearchResult?.count, nil)
        
        //When
        RawgClient.searchGames(gameName: "Cyberpunk 2077") { [weak self] gameSearchResult, error in
            guard let self = self else { return }
            self.gameSearchResult = gameSearchResult
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertEqual(gameSearchResult?[0].name, "Cyberpunk 2077")
        
    }
    
    func testSearchGameEmpty() throws {
        let fetchExpectation = expectation(description: "fetchGameSearch")
        
        //Given
        XCTAssertEqual(gameSearchResult?.count, nil)
        
        //When
        RawgClient.searchGames(gameName: "") { [weak self] gameSearchResult, error in
            guard let self = self else { return }
            self.gameSearchResult = gameSearchResult
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertNotNil(gameSearchResult)
    }
    
    func testSearchGameEdgeCase() throws {
        let fetchExpectation = expectation(description: "fetchGameSearch")
        
        //Given
        XCTAssertEqual(gameSearchResult?.count, nil)
        
        //When
        let str = String(
            bytes: [0xD8, 0x00] as [UInt8],
            encoding: .utf16BigEndian)!
        
        RawgClient.searchGames(gameName: str) { [weak self] gameSearchResult, error in
            guard let self = self else { return }
            self.gameSearchResult = gameSearchResult
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10)
        
        //Then
        XCTAssertEqual(gameSearchResult?.count, 0)
    }
    

}
