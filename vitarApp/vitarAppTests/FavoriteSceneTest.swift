//
//  FavoriteSceneTest.swift
//  vitarAppTests
//
//  Created by Kerem Safa Dirican on 18.12.2022.
//

import XCTest

final class FavoriteSceneTest: XCTestCase {
    

    var viewModel: FavoriteSceneViewModelProtocol = FavoriteSceneViewModel()
    
    func testFavorite() throws {
        //Given
        XCTAssertEqual(viewModel.getGameCount(), 0)
        XCTAssertNil(viewModel.getGameId(at: 0))
        XCTAssertNil(viewModel.getGame(at: 0))
        
    }
}
