//
//  NoteSceneViewModel.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 17.12.2022.
//

import Foundation

//MARK: - Protocols
protocol NoteSceneViewModelProtocol {
    var delegate: NoteSceneViewModelDelegate? { get set }
    func fetchNotes()
    func getNoteCount() -> Int
    func getNote(at index: Int) -> Note?
    func deleteNote(at index:Int)
    func editNote(obj:Note, newObj:NoteModel)
    
    func getGameId(at index: Int) -> Int?
    func getGameImageID(at index: Int) -> String?
    
}

protocol NoteSceneViewModelDelegate: AnyObject {
    func notesLoaded()
}

//MARK: - Classes
final class NoteSceneViewModel: NoteSceneViewModelProtocol {
    weak var delegate: NoteSceneViewModelDelegate?
    private var notes = [Note]()
    
    func fetchNotes() {
        Globals.sharedInstance.isNotesChanged = false
        notes = NoteCoreDataManager.shared.getNotes()
        notes = notes.reversed()
        delegate?.notesLoaded()
    }
    
    func getNoteCount() -> Int {
        notes.count
    }
    
    func getNote(at index: Int) -> Note? {
        if index > notes.count - 1{
            return nil
        }
        return notes[index]
    }
    
    func deleteNote(at index:Int){
        NoteCoreDataManager.shared.deleteNote(note: notes[index])
        notes.remove(at: index)
        delegate?.notesLoaded()
        
    }
    
    func editNote(obj:Note, newObj:NoteModel){
        NoteCoreDataManager.shared.editNote(obj: obj,newObj: newObj)
    }
    
    func getGameId(at index: Int) -> Int? {
        if index > notes.count - 1{
            return nil
        }
        return Int(notes[index].gameId)
    }
    
    
    func getGameImageID(at index: Int) -> String? {
        if index > notes.count - 1{
            return nil
        }
        return notes[index].imageId
    }
}
//MARK: -
