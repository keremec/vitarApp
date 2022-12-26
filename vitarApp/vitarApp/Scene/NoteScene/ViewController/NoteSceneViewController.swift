//
//  NoteSceneViewController.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 17.12.2022.
//

import UIKit

class NoteSceneViewController: UIViewController {
    
    //MARK: - Outlets and Variables
    
    
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            statusLabel.text = NSLocalizedString("ZERO_NOTE", comment: "You dont have any note")
            statusLabel.isHidden = true
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var newNoteButton: UIButton!
    @IBOutlet private weak var noteListTableView: UITableView!{
        didSet{
            noteListTableView.delegate = self
            noteListTableView.dataSource = self
            noteListTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
            noteListTableView.rowHeight = 150.0
        }
    }
    
    private var viewModel: NoteSceneViewModelProtocol = NoteSceneViewModel()
    
    //MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("NOTES_PAGE", comment: "Notes Page")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleError),
                                               name: NSNotification.Name("noteGamesErrorMessage"),
                                               object: nil)
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.fetchNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(Globals.sharedInstance.isNotesChanged){
            viewModel.fetchNotes()
        }
    }
    //MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NotestoNoteDetail":
            if let note = sender as? Note{
                let goalVC = segue.destination as! NoteDetailSceneViewController
                let game = RawgModel(id: Int(note.gameId), tba: nil, name: note.gameTitle, released: nil, metacritic: nil, rating: nil, parentPlatforms: nil, genres: nil, imageWide: note.imageUrl)
                goalVC.delegateNoteScene = self
                goalVC.game = game
                goalVC.note = note
            }
        case "NotestoNewNote":
            let goalVC = segue.destination as! NoteDetailSceneViewController
            goalVC.delegateNoteScene = self
        default:
            print("identifier not found")
        }
    }
    
    //MARK: - Actions
    @IBAction func newNoteAction(_ sender: Any) {
        performSegue(withIdentifier: "NotestoNewNote", sender: nil)
    }
    
}
//MARK: - Delegate Functions
extension NoteSceneViewController: NoteSceneViewModelDelegate {
    func notesLoaded() {
        activityIndicator.stopAnimating()
        noteListTableView.reloadData()
    }
}
//MARK: - Tableview Functions
extension NoteSceneViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getNoteCount()
        if count <= 0{
            statusLabel.isHidden = false
        }
        else{
            statusLabel.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteTableViewCell,
              let obj = viewModel.getNote(at: indexPath.row) else {return UITableViewCell()}
        DispatchQueue.main.async {
            cell.configureCell(obj)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let note = viewModel.getNote(at: indexPath.row){
            performSegue(withIdentifier: "NotestoNoteDetail", sender: note)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = viewModel.getNote(at: indexPath.row)
        
        let deleteConfirmAction = UIContextualAction(style: .destructive, title: NSLocalizedString("DELETE_NOTE", comment: "Delete")){ (contextualAction, view, bool ) in
            let alert = UIAlertController(title: NSLocalizedString("CONFIRM_DELETE_NOTE", comment: "Do you want to delete this note?"), message: "\(note?.noteTitle! ?? "")", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL_TEXT", comment: "Cancel"), style: .cancel){action in
                tableView.reloadRows(at: [indexPath], with: .right)
                tableView.reloadData()
            }
            
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: NSLocalizedString("DELETE_NOTE", comment: "Delete"), style: .destructive){action in
                self.viewModel.deleteNote(at: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .left)
                
            }
            alert.addAction(yesAction)
            // ipad Compatibility, min req ios 16
            alert.popoverPresentationController?.sourceItem = self.newNoteButton
            self.newNoteButton.isHidden = false
            self.present(alert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteConfirmAction])
        
    }
    
}

//MARK: - Scrollview Functions
extension NoteSceneViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == noteListTableView{
            newNoteButton.isHidden = scrollView.contentOffset.y > 0
        }
    }
}

//MARK: -
