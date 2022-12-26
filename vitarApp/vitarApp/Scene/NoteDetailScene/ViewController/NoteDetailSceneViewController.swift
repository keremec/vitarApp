//
//  NoteDetailSceneViewController.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 17.12.2022.
//

import UIKit

class NoteDetailSceneViewController: UIViewController {

    //MARK: - Outlets and Variables
    @IBOutlet private weak var saveButton: UIButton!{
        didSet{
            saveButton.setTitle(NSLocalizedString("SAVE_TEXT", comment: "Save"), for: .normal)
            saveButton.setTitle(NSLocalizedString("SAVE_TEXT", comment: "Save"), for: .disabled)
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.setTitle(NSLocalizedString("CANCEL_TEXT", comment: "Cancel"), for: .normal)
        }
    }
    
    @IBOutlet private weak var noteTitle: UITextField!{
        didSet{
            noteTitle.placeholder = NSLocalizedString("PLACEHOLDER_NOTE_TITLE", comment: "Note Title")
        }
    }
    @IBOutlet private weak var noteDetail: UITextView!{
        didSet{
            noteDetail.delegate = self
        }
    }
    @IBOutlet private weak var gameButton: UIButton!
    
    private var viewModel: NoteSceneDetailViewModelProtocol = NoteSceneDetailViewModel()
    
    var note: Note?
    var game: RawgModel?
    private var updatedNote: NoteModel?
    weak var delegateNoteScene: NoteSceneViewController?
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitle.text = note?.noteTitle ?? ""
        noteDetail.text = note?.noteDetail ?? ""
        if noteDetail.text == ""{
            noteDetail.text = NSLocalizedString("PLACEHOLDER_NOTE", comment: "Placeholder")
            noteDetail.textColor = UIColor.placeholderText
        }
        gameButton.setTitle(NSLocalizedString("SELECT_BUTTON_TEXT", comment: "Please Select Game"), for: .normal)
        setGame(game: game, willValidate: false)
    }
    
    //MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NotetoSearch":
            let goalVC = segue.destination as! SearchSceneViewController
            goalVC.modalCall = 1
            goalVC.delegateNote = self
        default:
            print("identifier not found")
        }
    }
    
    //MARK: - Action Triggers
    @IBAction private func didTitleChanged(_ sender: Any) {
        saveValidator()
    }
    
    @IBAction private func saveAction(_ sender: Any) {
        setUpdatedNote()
        if let updatedNote{
            if let note{
                viewModel.editNote(obj: note, newObj: updatedNote)
            }
            else{
                viewModel.newNote(obj: updatedNote)
            }
            Globals.sharedInstance.isNotesChanged = true
            delegateNoteScene?.viewWillAppear(true)
            self.dismiss(animated: true)
        }
        
    }
    
    
    @IBAction private func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction private func gameAction(_ sender: Any) {
        performSegue(withIdentifier: "NotetoSearch", sender: nil)
    }

    //MARK: - Global Functions
    func setGame(game:RawgModel?, willValidate:Bool = true){
        if let game{
            self.game = game
            gameButton.configuration = .gray()
            gameButton.configuration?.imagePadding = 5
            gameButton.setTitle(game.name, for: .normal)
            gameButton.tintColor = UIColor.systemPurple
            gameButton.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
        }
        if(willValidate){
            saveValidator()
        }
    }
    
    //MARK: - Private Functions
    private func saveValidator(){
        saveButton.isEnabled = false
        guard !(noteTitle.text?.isEmpty ?? true) else {return}
        guard !noteDetail.text.isEmpty else{ return }
        guard noteDetail.textColor == UIColor.label else{ return }
        guard game != nil else{return}
        saveButton.isEnabled = true
    }
    
    private func setUpdatedNote(){
        updatedNote = NoteModel(gameId: Int64(game?.id ?? 0), gameTitle: game?.name, imageId: getGameImageID(imgUrl: game?.imageWide), imageUrl: game?.imageWide, noteDetail: noteDetail.text, noteTitle: noteTitle.text)
    }
    
    
    private func getGameImageID(imgUrl:String?) -> String? {
        URL(string: imgUrl ?? "")?.lastPathComponent
    }
    
}

//MARK: - Textview Functions
extension NoteDetailSceneViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteDetail.textColor == UIColor.placeholderText{
            noteDetail.text = nil
            noteDetail.textColor = UIColor.label
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveValidator()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteDetail.text.isEmpty {
            noteDetail.text = NSLocalizedString("PLACEHOLDER_NOTE", comment: "Placeholder")
            noteDetail.textColor = UIColor.placeholderText
        }
    }
}
