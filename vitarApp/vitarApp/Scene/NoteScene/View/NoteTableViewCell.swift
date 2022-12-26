//
//  NoteTableViewCell.swift
//  vitarApp
//
//  Created by Kerem Safa Dirican on 17.12.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var gameTitle: UILabel!
    
    @IBOutlet private weak var noteTitle: UILabel!
    
    @IBOutlet private weak var noteDetail: UITextView!
    
    @IBOutlet private weak var gameImage: UIImageView!
    
    //MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        gameImage.layer.cornerRadius = 7.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Global Functions
    func configureCell(_ note:Note){
        gameTitle.text = note.gameTitle
        noteTitle.text = note.noteTitle
        noteDetail.text = note.noteDetail
        changeImage(imgUrl: note.imageUrl)
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
