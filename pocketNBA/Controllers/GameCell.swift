//
//  GameCell.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/10/21.
//

import UIKit
import QuartzCore

class GameCell: UITableViewCell {
    
    @IBOutlet weak var awayTeamImgView: UIImageView!
    @IBOutlet weak var homeTeamImgView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var awayStar: UIImageView!
    @IBOutlet weak var homeStar: UIImageView!
    
    let userDefaults = UserDefaults.standard
    
    func setGameCell(_ game: Game){
        updateStars(game)
        self.awayTeamNameLabel.text = game.AwayTeam
        self.homeTeamNameLabel.text = game.HomeTeam
        self.awayTeamImgView.image = UIImage(named: game.AwayTeam)
        self.homeTeamImgView.image = UIImage(named: game.HomeTeam)
        self.awayTeamScoreLabel.text = game.HomeTeamScore
        self.homeTeamScoreLabel.text = game.AwayTeamScore
        self.dateLabel.text = game.dateString
    }
    
    func updateStars(_ game: Game){
        if game.HomeTeam == userDefaults.string(forKey: "Fav"){
            homeStar.isHidden = false
        } else{
            homeStar.isHidden = true
        }
        
        if game.AwayTeam == userDefaults.string(forKey: "Fav"){
            awayStar.isHidden = false
        } else{
            awayStar.isHidden = true
        }
        
    }
}
