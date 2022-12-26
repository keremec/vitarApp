//
//  NoteTableViewCellTest.swift
//  vitarAppTests
//
//  Created by Kerem Safa Dirican on 18.12.2022.
//

import XCTest

final class GameDetailSceneTest: XCTestCase {

    var fetchExpectation: XCTestExpectation?
    
    
    //MARK: - Get Detail Tests
    func testGetGameDetail() throws {
        var viewModel: GameDetailSceneViewModelProtocol = GameDetailSceneViewModel()
        viewModel.delegate = self
        fetchExpectation = expectation(description: "fetchGameDetail")
        
        
        //Given
        XCTAssertNil(viewModel.getGameDate())
        XCTAssertNotNil(viewModel.getGameInfo())
        XCTAssertNil(viewModel.getGameScore())
        XCTAssertEqual(viewModel.getGameTitle(), "")
        XCTAssertEqual(viewModel.getGameRating(), "NR")
        XCTAssertEqual(viewModel.getGameDetail(), "")
        XCTAssertNotNil(viewModel.getGamePublisher())
        XCTAssertNil(viewModel.getGameImageUrl(3))
        XCTAssertNil(viewModel.getGamePlatforms())
        
        //When
        viewModel.fetchGameDetail(41494)
        waitForExpectations(timeout: 10)
        //Then
        XCTAssertEqual(viewModel.getGameTitle(), "Cyberpunk 2077")
        XCTAssertNotNil(viewModel.getGameDate())
        XCTAssertNotNil(viewModel.getGameInfo())
        XCTAssertNotNil(viewModel.getGameScore())
        XCTAssertEqual(viewModel.getGameRating(), "M")
        XCTAssertNotEqual(viewModel.getGameDetail(), "")
        XCTAssertNotNil(viewModel.getGamePublisher())
        XCTAssertNotNil(viewModel.getGameImageUrl(3))
        XCTAssertNotNil(viewModel.getGamePlatforms())
        
    }
    
    
}


extension GameDetailSceneTest: GameDetailSceneViewModelDelegate{
    func gameLoaded() {
        fetchExpectation?.fulfill()
    }
    
}
