//
//  SearchSceneTest.swift
//  vitarAppTests
//
//  Created by Kerem Safa Dirican on 18.12.2022.
//

import XCTest

final class SearchSceneTest: XCTestCase {

    var fetchExpectation: XCTestExpectation?
    var callCount = 0
    
    //MARK: - Get Popular Tests
    func testSearchGames() throws {
        var viewModel: HomeSceneViewModelProtocol = HomeSceneViewModel()
        viewModel.delegate = self
        fetchExpectation = expectation(description: "fetchGames")
        
        
        //Given
        
        //When
        viewModel.searchGames("Cyberpunk")
        waitForExpectations(timeout: 10)
        //Then
        XCTAssertNotNil(viewModel.getGame(at: 1))
        XCTAssertNotNil(viewModel.getGameId(at: 1))
        
    }
    
    
}


extension SearchSceneTest: HomeSceneViewModelDelegate{
    func gamesLoaded() {
            fetchExpectation?.fulfill()
    }
    
}
