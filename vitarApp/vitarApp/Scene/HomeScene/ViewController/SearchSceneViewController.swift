//
//  SearchSceneViewController.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 14.12.2022.
//

import UIKit

class SearchSceneViewController: UIViewController {
    
    //MARK: - Outlets and Variables
    var modalCall:Int?
    weak var delegateNote: NoteDetailSceneViewController?

        
    @IBOutlet weak var searchStatusLabel: UILabel!{
        didSet{
            statusHelper(0)
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var gameListTableView: UITableView!{
        didSet{
            gameListTableView.delegate = self
            gameListTableView.dataSource = self
            gameListTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameCell")
            gameListTableView.rowHeight = 150.0
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    private var viewModel: HomeSceneViewModelProtocol = HomeSceneViewModel()
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("SEARCH_PAGE", comment: "Search Games")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleError),
                                               name: NSNotification.Name("searchGamesErrorMessage"),
                                               object: nil)
        viewModel.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    //MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SearchtoDetail":
            if let gameId = sender as? Int{
                let goalVC = segue.destination as! GameDetailSceneViewController
                goalVC.gameId = gameId
            }
        default:
            print("identifier not found")
        }
    }
    //MARK: - Helper Action
    private func statusHelper(_ status:Int){
        searchStatusLabel.tag = status
        switch status {
        case 0:
            searchStatusLabel.text = NSLocalizedString("CAN_SEARCH_GAME", comment: "You can Search Game")
            searchStatusLabel.isHidden = false
        case 1:
            searchStatusLabel.isHidden = true
            activityIndicator.startAnimating()
        case 2:
            searchStatusLabel.text = NSLocalizedString("NO_RESULT", comment: "No Result")
            searchStatusLabel.isHidden = false
        case 3:
            searchStatusLabel.isHidden = true
        default:
            searchStatusLabel.isHidden = true
            searchStatusLabel.text = ""
        }
    }
}


//MARK: - Delegate Functions
extension SearchSceneViewController: HomeSceneViewModelDelegate {
    func gamesLoaded() {
        gameListTableView.reloadData()
        activityIndicator.stopAnimating()
    }
}

//MARK: - Tableview Functions
extension SearchSceneViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getGameCount()
        if searchStatusLabel.tag == 0{
            statusHelper(0)
        }
        else if count <= 0 {
            statusHelper(2)
        }
        else{
            statusHelper(3)
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameTableViewCell,
              let obj = viewModel.getGame(at: indexPath.row) else {return UITableViewCell()}
        DispatchQueue.main.async {
                cell.configureCell(obj)
        }
        return cell
    }
    // Segue Actions - Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let modalCall{
            switch modalCall {
            case 1:
                delegateNote?.setGame(game: viewModel.getGame(at: indexPath.row))
                dismiss(animated: true)
            default:
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        if let gameId = viewModel.getGameId(at: indexPath.row){
            performSegue(withIdentifier: "SearchtoDetail", sender: gameId)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - Searchbar Action

extension SearchSceneViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            statusHelper(1)
            viewModel.searchGames(text)
            self.view.endEditing(true)
        }
    }
    
}
//MARK: -
