//
//  GameDetailViewController.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 14.12.2022.
//

import UIKit
import UIImageColors

class GameDetailSceneViewController: UIViewController {
    
    //MARK: - Outlets and Variables

    
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var gameImageView: UIImageView!{
        didSet{
            gameImageView.layer.cornerRadius = 7.5
        }
    }
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var ratingOutlet: UIButton!{
        didSet{
            ratingOutlet.titleLabel?.text = ""
        }
    }
    @IBOutlet private weak var dateOutlet: UIButton!{
        didSet{
            dateOutlet.titleLabel?.text = ""
        }
    }
    @IBOutlet private weak var scoreOutlet: UIButton!{
        didSet{
            scoreOutlet.titleLabel?.text = ""
        }
    }
    @IBOutlet private weak var detailText: UITextView!
    @IBOutlet private weak var platformPC: UIButton!
    @IBOutlet private weak var platformXbox: UIButton!
    @IBOutlet private weak var platformSony: UIButton!
    @IBOutlet private weak var platformNintendo: UIButton!
    
    
    @IBOutlet private weak var likeGameOutlet: UIButton!
    
    var gameId: Int?
    var delegateFavorite: FavoriteSceneViewController?
    private var viewModel: GameDetailSceneViewModelProtocol = GameDetailSceneViewModel()
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = gameId else { return }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleError),
                                               name: NSNotification.Name("detailGamesErrorMessage"),
                                               object: nil)
        viewModel.delegate = self
        activityIndicator.startAnimating()
        viewModel.fetchGameDetail(id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            if Globals.sharedInstance.isFavoriteChanged{
                delegateFavorite?.viewWillAppear(true)
            }
        }
    }
    //MARK: - Actions
    @IBAction func pressLikeGame(_ sender: Any) {
        favoriteHandler(status: viewModel.handleFavorite())
    }
    
    @IBAction func pressInfoGame(_ sender: Any) {
        if let url = URL(string: Globals.sharedInstance.backlinkHelper(id: gameId)){
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - UI Helpers
    private func enablePlatform(id:Int){
        switch id {
        case -1:
            platformPC.isHidden = true
            platformXbox.isHidden = true
            platformSony.isHidden = true
            platformNintendo.isHidden = true
        case 1:
            platformPC.isHidden = false
        case 2:
            platformSony.isHidden = false
        case 3:
            platformXbox.isHidden = false
        case 7:
            platformNintendo.isHidden = false
        default:
            break
        }
        
    }
    private func favoriteHandler(status:Bool?){
        if let status{
            if status{
                likeGameOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                likeGameOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            likeGameOutlet.isHidden = false
            return
        }
        likeGameOutlet.isHidden = true
        return
    }
    
    
    private func colorPage(){
        backgroundContainer.isHidden = false
        DispatchQueue.main.async {
            self.gameImageView.image?.getColors(quality: .lowest){colors in
                UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve) {
                    self.publisherLabel.textColor = colors?.detail
                    self.titleLabel.textColor = colors?.primary
                    self.infoLabel.textColor = colors?.secondary
                    self.detailText.textColor = colors?.detail
                    
                    self.likeGameOutlet.tintColor = colors?.primary
                    
                    self.ratingOutlet.tintColor = colors?.primary
                    let tempDate = self.dateOutlet.titleLabel?.text
                    self.dateOutlet.tintColor = colors?.primary
                    self.dateOutlet.titleLabel?.text = tempDate
                    self.scoreOutlet.tintColor = colors?.primary
                    self.platformPC.tintColor = colors?.primary
                    self.platformXbox.tintColor = colors?.primary
                    self.platformSony.tintColor = colors?.primary
                    self.platformNintendo.tintColor = colors?.primary
                    
                    self.view.backgroundColor = colors?.background
                }
            }
        }
    }
}

//MARK: - Delegate Functions
extension GameDetailSceneViewController: GameDetailSceneViewModelDelegate{
    func gameLoaded() {
            if let id = self.gameId{
                self.favoriteHandler(status: self.viewModel.isFavoriteGame(id))
            }
            self.publisherLabel.text = self.viewModel.getGamePublisher()
            self.titleLabel.text = self.viewModel.getGameTitle()
            self.infoLabel.text = self.viewModel.getGameInfo()
            self.ratingOutlet.setTitle(self.viewModel.getGameRating(), for: .normal)
            if let date = self.viewModel.getGameDate(){
                self.dateOutlet.titleLabel?.text = date
            }else{
                self.dateOutlet.setTitle(NSLocalizedString("TBA_DATE", comment: "Release Date"), for: .normal)
            }
            
            if let score = self.viewModel.getGameScore(){
                self.scoreOutlet.setTitle(score, for: .normal)
            }else{
                self.scoreOutlet.setTitle("", for: .normal)
                self.scoreOutlet.setImage(UIImage(systemName: "star.slash"), for: .normal)
            }
            self.detailText.text = self.viewModel.getGameDetail()
        
        self.gameImageView.kf.indicatorType = .activity
        self.gameImageView.kf.setImage(with: self.viewModel.getGameImageUrl(640), placeholder: nil){_ in
            if(Globals.sharedInstance.isLocalColorCalculationEnabled){
                self.colorPage()
            }
        }
            if let platforms = self.viewModel.getGamePlatforms(){
                for i in platforms{
                    self.enablePlatform(id: i.platform?.id ?? 0)
                }
            }
        activityIndicator.stopAnimating()
    }
    
    
}
