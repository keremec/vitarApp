//
//  NoteSceneTest.swift
//  vitarAppTests
//
//  Created by Kerem Safa Dirican on 18.12.2022.
//

import XCTest

final class NoteSceneTest: XCTestCase {

    
    var viewModel: NoteSceneViewModelProtocol = NoteSceneViewModel()
    
    func testNotes() throws {
        //Given
        XCTAssertNil(viewModel.getNote(at: 0))
        XCTAssertNil(viewModel.getGameId(at: 0))
        XCTAssertNil(viewModel.getGameImageID(at: 0))
        XCTAssertNil(viewModel.getNote(at: 0))
        
        XCTAssertEqual(viewModel.getNoteCount(), 0)
        
    }

}
