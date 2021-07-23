//
//  NearbyTeamsVC.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/17/21.
//

import UIKit

class NearbyTeamsVC: UIViewController {
    
    var teams: [NearbyTeams] = []
    var currentKey: String = ""
    var currentTeam: NearbyTeams = NearbyTeams(StadiumId: 999, DistanceFromUser: 1000000, Key: "None")
    
    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var thirdTeamImageView: UIImageView!
    @IBOutlet weak var fourthTeamImageView: UIImageView!
    
    @IBOutlet weak var firstTeamLabel: UILabel!
    @IBOutlet weak var secondTeamLabel: UILabel!
    @IBOutlet weak var thirdTeamLabel: UILabel!
    @IBOutlet weak var fourthTeamLabel: UILabel!
    
    @IBOutlet weak var firstTeamButton: UIButton!
    @IBOutlet weak var secondTeamButton: UIButton!
    @IBOutlet weak var thirdTeamButton: UIButton!
    @IBOutlet weak var fourthTeamButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    func updateUI(){
        let imageViews: [UIImageView] = [firstTeamImageView, secondTeamImageView, thirdTeamImageView, fourthTeamImageView]
        loadImages(for: imageViews)
        
        let labels: [UILabel] = [firstTeamLabel, secondTeamLabel, thirdTeamLabel, fourthTeamLabel]
        loadLabels(for: labels)
    }
    
    func loadImages(for imageViewArray: [UIImageView]){
        for i in 0...3{
            imageViewArray[i].image = UIImage(named: self.teams[i].Key)
        }
    }
    
    func loadLabels(for labelsArray: [UILabel]){
        for i in 0...3 {
            let team = self.teams[i]
            let labelString = "\(team.Name) \n \(team.DistanceFromUser.rounded()) miles away"
            labelsArray[i].text = labelString
        }
    }
    
    @IBAction func teamSelected(_ sender: UIButton) {
        let index = sender.tag - 1
        self.currentTeam = self.teams[index]
        self.performSegue(withIdentifier: "unwind", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FavoriteTeamViewController
        destinationVC.currentTeam = self.currentTeam
        let row = findElementInArray(self.currentTeam.Key, destinationVC.teams)
        destinationVC.teamPickerView.selectRow(row, inComponent: 0, animated: true)
        destinationVC.teamImageView.image = UIImage(named: self.currentTeam.Key)
    }
    
    func findElementInArray(_ key: String, _ array: [NearbyTeams]) -> Int {
        var currIndex = 0
        for team in array{
            if key == team.Key{
               break
            }
            currIndex += 1
        }
        return currIndex
    }
    
}
