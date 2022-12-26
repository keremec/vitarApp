//
//  GameTableViewCell.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 13.12.2022.
//

import UIKit
import Kingfisher

final class GameTableViewCell: UITableViewCell {

    //MARK: - Outlets and Variables
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var gameTitle: UILabel!
    @IBOutlet private weak var gameInfo: UILabel!
    
    @IBOutlet private weak var platformPC: UIButton!
    @IBOutlet private weak var platformXbox: UIButton!
    @IBOutlet private weak var platformSony: UIButton!
    @IBOutlet private weak var platformNintendo: UIButton!
    
    
    //MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        gameImage.layer.cornerRadius = 7.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        enablePlatform(id: -1)
        gameImage.image = nil
    }

    
    //MARK: - Public Functions
    func configureCell(_ game:RawgModel){
        gameTitle.text = game.name
        gameInfo.text = gameInfoCreator(game)
        changeImage(imgUrl: game.imageWide)
        if let platforms = game.parentPlatforms{
            for i in platforms{
                enablePlatform(id: i.platform?.id ?? 0)
            }
        }
    }
    
    
    //MARK: - UI Helpers
    private func gameInfoCreator(_ game:RawgModel) -> String{
        let dateString = (game.tba ?? false) ? "TBA" : (game.released?.prefix(4) ?? "TBA")
        var genreString = ""
        if let genres = game.genres, ((game.genres?.count ?? 0) != 0){
            for i in genres{
                genreString += i.name ?? ""
                genreString += ", "
            }
            genreString.removeLast(2)
        }
        return "\(dateString) | \(genreString) "
    }
    
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
//MARK: -
