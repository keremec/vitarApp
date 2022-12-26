//
//  NoteDetailSceneViewModel.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 17.12.2022.
//

import Foundation

//MARK: - Protocols
protocol NoteSceneDetailViewModelProtocol {
    var delegate: NoteSceneDetailViewModelDelegate? { get set }
    func newNote(obj:NoteModel)
    func editNote(obj:Note, newObj:NoteModel)
}

protocol NoteSceneDetailViewModelDelegate: AnyObject {
    func notesLoaded()
}

//MARK: - Classes
final class NoteSceneDetailViewModel: NoteSceneDetailViewModelProtocol {
    weak var delegate: NoteSceneDetailViewModelDelegate?
    private var notes = [Note]()
    
    func newNote(obj: NoteModel) {
        _ = NoteCoreDataManager.shared.saveNote(obj: obj)
    }
    
    
    func editNote(obj:Note, newObj:NoteModel){
        NoteCoreDataManager.shared.editNote(obj: obj,newObj: newObj)
    }
    
}
//MARK: -
