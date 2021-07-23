//
//  TeamCell.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/13/21.
//

import UIKit

class TeamCell: UITableViewCell {

    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var favoriteTeamStar: UIImageView!
    
    let userDefaults = UserDefaults.standard
    
    
    func setTeamCell(_ team: Standings){
        //self.positionLabel.text = "\(team.rank)"
        
        if team.Key == userDefaults.string(forKey: "Fav"){
            favoriteTeamStar.isHidden = false
        } else {
            favoriteTeamStar.isHidden = true
        }
        
        self.logoImageView.image = UIImage(named: team.Key)
        self.teamNameLabel.text = "\(team.Key)"
        self.recordLabel.text = "\(team.Wins) - \(team.Losses)"
    }
 
    
}
