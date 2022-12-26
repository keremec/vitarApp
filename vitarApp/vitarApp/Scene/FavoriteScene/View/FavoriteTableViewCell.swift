//
//  FavoriteTableViewCell.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 15.12.2022.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    //MARK: - Outlets and Variables
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var gameTitle: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var ratingOutlet: UIButton!
    @IBOutlet private weak var scoreOutlet: UIButton!
    @IBOutlet private weak var dateOutlet: UIButton!
    
    //MARK: - Life Cycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        gameImage.layer.cornerRadius = 7.5
    }
    
    override func prepareForReuse() {
        gameImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Public Functions
    func configureCell(_ game:RawgDetailModel){
        gameTitle.text = game.name
        setPublisherLabel(game)
        setGameRating(game.rating?.id)
        setGameScore(metacritic: game.metacritic)
        setGameDate(game)

        changeImage(imgUrl: game.imageWide)
    }
    
    
    //MARK: - UI Helpers
    private func setGameRating(_ id: Int?){
        ratingOutlet.setTitle(Globals.sharedInstance.Esrb(id: id), for: .normal)
    }
    
    private func setGameDate(_ game: RawgDetailModel){
        if game.tba ?? false || game.released == nil{
            dateOutlet.setTitle(NSLocalizedString("TBA_DATE", comment: "Release Date"), for: .normal)
            return
        }
        dateOutlet.setTitle(Globals.sharedInstance.formatDate(date: game.released!), for: .normal)
    }
    
    private func setGameScore(metacritic:Int?){
        if let score:Int = metacritic{
            scoreOutlet.setTitle(String(score), for: .normal)
            self.scoreOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
            return
        }
        scoreOutlet.setTitle("", for: .normal)
        scoreOutlet.setImage(UIImage(systemName: "star.slash"), for: .normal)
    }
    
    private func setPublisherLabel(_ game:RawgDetailModel){
        var leadStudio = ""
        var mainPublisher = ""
        if let studios = game.developers{
            if studios.count > 0{
                leadStudio = studios[0].name ?? "-"
            }
        }
        
        if let publishers = game.publishers{
            if publishers.count > 0{
                mainPublisher = publishers[0].name ?? "-"
            }
        }
        
        publisherLabel.text = "\(leadStudio), \(mainPublisher)"
    }
    
    //MARK: - Private Functions
    private func changeImage(imgUrl:String?){
        if let imgSized = Globals.sharedInstance.resizeImageRemote(imgUrl: imgUrl){
            guard let url = URL(string: imgSized) else { return }
            DispatchQueue.main.async {
                self.gameImage.kf.setImage(with: url, placeholder: nil)
            }
        }
    }
    
}

