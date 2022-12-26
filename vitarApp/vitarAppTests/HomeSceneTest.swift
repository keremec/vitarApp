//
//  HomeSceneTest.swift
//  vitarAppTests
//
//  Created by Kerem Safa Dirican on 18.12.2022.
//

import XCTest

final class HomeSceneTest: XCTestCase {

    var fetchExpectation: XCTestExpectation?
    var orderExpectation: XCTestExpectation?
    var callCount = 0
    
    //MARK: - Get Popular Tests
    func testHomeScene() throws {
        var viewModel: HomeSceneViewModelProtocol = HomeSceneViewModel()
        viewModel.delegate = self
        fetchExpectation = expectation(description: "fetchGames")
        
        
        //Given
        
        //When
        viewModel.fetchPopularGames()
        waitForExpectations(timeout: 10)
        orderExpectation = expectation(description: "orderGames")
        viewModel.orderList(opt: 1)
        waitForExpectations(timeout: 10)
        //Then
        XCTAssertNotNil(viewModel.getGame(at: 1))
        XCTAssertNotNil(viewModel.getGameId(at: 1))
        
    }
    
    
}


extension HomeSceneTest: HomeSceneViewModelDelegate{
    func gamesLoaded() {
        switch callCount {
        case 0:
            fetchExpectation?.fulfill()
        case 1:
            orderExpectation?.fulfill()
        default:
            break
        }
        callCount += 1
    }
    
}
