//
//  FavoriteSceneViewModel.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 15.12.2022.
//

import Foundation

//MARK: - Protocols
protocol FavoriteSceneViewModelProtocol {
    var delegate: FavoriteSceneViewModelDelegate? { get set }
    func fetchFavoriteGames()
    func getGameCount() -> Int
    func getGame(at index: Int) -> RawgDetailModel?
    func getGameId(at index: Int) -> Int?
    func removeGame(at index:Int)
}

protocol FavoriteSceneViewModelDelegate: AnyObject {
    func favoritesLoaded()
}

//MARK: - Classes
final class FavoriteSceneViewModel: FavoriteSceneViewModelProtocol {
    weak var delegate: FavoriteSceneViewModelDelegate?
    private var favorites = [Favorite]()
    private var games: [RawgDetailModel]?
    
    // First gets favorites from CoreData
    // then fills the data asynchronously
    func fetchFavoriteGames() {
        Globals.sharedInstance.isFavoriteChanged = false
        games = [RawgDetailModel]()
        favorites = FavoriteCoreDataManager.shared.getFavorites()
        favorites = favorites.reversed()
        var onQueue = favorites.count
        if favorites.count <= 0{
            delegate?.favoritesLoaded()
            return
        }
        for i in favorites.enumerated(){
            games?.append(RawgDetailModel(id: Int(i.element.gameId)))
            RawgClient.getGameDetail(gameId: Int(i.element.gameId)) { [weak self] game, error in
                guard let self = self else { return }
                if let game{
                    if game.id == nil{
                        self.favorites.removeAll()
                        NotificationCenter.default.post(name: NSNotification.Name("favoriteGamesErrorMessage"), object: NSLocalizedString("FETCH_ERROR", comment: "Game Data Fetch Error"))
                        return
                    }
                    self.games?[i.offset] = game
                    onQueue -= 1
                    if(onQueue <= 0){
                        self.delegate?.favoritesLoaded()
                    }
                }
            }
        }
    }
    
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> RawgDetailModel? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        games?[index].id
    }
    
    func getGameImageID(at index: Int) -> String? {
        URL(string: games?[index].imageWide ?? "")?.lastPathComponent
    }
    
    func removeGame(at index:Int){
        FavoriteCoreDataManager.shared.deleteFavorite(game: favorites[index])
        favorites.remove(at: index)
        games?.remove(at: index)
        self.delegate?.favoritesLoaded()
    }
    
}


