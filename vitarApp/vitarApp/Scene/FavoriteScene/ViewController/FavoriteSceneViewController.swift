//
//  FavoriteSceneViewController.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 15.12.2022.
//

import UIKit


class FavoriteSceneViewController: UIViewController {
    
    //MARK: - Outlets and Variables
    
    
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            statusLabel.text = NSLocalizedString("NO_FAVORITE", comment: "You don't Have Favorite")
            statusLabel.isHidden = true
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var favoriteListTableView: UITableView!{
        didSet{
            favoriteListTableView.delegate = self
            favoriteListTableView.dataSource = self
            favoriteListTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
            favoriteListTableView.rowHeight = 150.0
        }
    }
    
    private var viewModel: FavoriteSceneViewModelProtocol = FavoriteSceneViewModel()
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("FAVORITES_PAGE", comment: "Favorite Games")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleError),
                                               name: NSNotification.Name("favoriteGamesErrorMessage"),
                                               object: nil)
        
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.fetchFavoriteGames()
        Globals.sharedInstance.isFavoriteChanged = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Globals.sharedInstance.isFavoriteChanged{
            activityIndicator.startAnimating()
            viewModel.fetchFavoriteGames()
        }
    }
    //MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FavoritetoDetail":
            if let gameId = sender as? Int{
                let goalVC = segue.destination as! GameDetailSceneViewController
                goalVC.gameId = gameId
                goalVC.delegateFavorite = self
            }
        default:
            print("identifier not found")
        }
    }
    
}

//MARK: - Delegate Functions

extension FavoriteSceneViewController: FavoriteSceneViewModelDelegate {
    func favoritesLoaded() {
        favoriteListTableView.reloadData()
        activityIndicator.stopAnimating()
    }
}

//MARK: - Tableview Functions
extension FavoriteSceneViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.getGameCount()
        if count <= 0{
            statusLabel.isHidden = false
        }
        else {
            statusLabel.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell,
              let obj = viewModel.getGame(at: indexPath.row) else {return UITableViewCell()}
        DispatchQueue.main.async {
            cell.configureCell(obj)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let gameId = viewModel.getGameId(at: indexPath.row){
            performSegue(withIdentifier: "FavoritetoDetail", sender: gameId)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("REMOVE_FAVORITE", comment: "Remove Favorite")){ (contextualAction, view, bool ) in
            self.viewModel.removeGame(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .left)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
//MARK: -
