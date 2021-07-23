//
//  StandingsViewController.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/13/21.
//

import UIKit

class StandingsVC: UIViewController {
    
    var standingsManager = StandingsManager()
    var standings: [Standings] = []

    @IBOutlet weak var conferenceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var standingsView: UITableView!
    
    
    //MARK: - View Life Cycle Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        standingsManager.delegate = self
        standingsView.delegate = self
        standingsView.dataSource = self
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Appeared")
        updateUI()
    }
    
    
    //MARK: - UI Updates
    func updateUI(){
        checkForEmptyArray()
        standingsManager.perfomRequest(for: 0)
        conferenceSegmentedControl.selectedSegmentIndex = 0
        standingsView.reloadData()
    }
    
    
    func checkForEmptyArray(){
        if self.standings.isEmpty{
            self.standingsView.isHidden = true
        } else{
            self.standingsView.isHidden = false
        }
    }
 
    
    @IBAction func conferenceChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        standingsManager.perfomRequest(for: sender.selectedSegmentIndex)
    }
    
}

//MARK: - Standings Manager Delegate
extension StandingsVC: StandingsManagerDelegate{
    func displayStandings(_ teams: [Standings]) {
        self.standings = teams
        DispatchQueue.main.async {
            self.standingsView.reloadData()
            self.checkForEmptyArray()
        }
    }
    

    func didFailWithError(err: Error) {
        print(err)
    }
}

//MARK: - TableView
extension StandingsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTeam = self.standings[indexPath.row]
        let cell = standingsView.dequeueReusableCell(withIdentifier: "TeamCell") as! TeamCell
        cell.setTeamCell(currentTeam)
        cell.positionLabel.text =
            "\(indexPath.row + 1)"
        return cell
    }
    
    
}
