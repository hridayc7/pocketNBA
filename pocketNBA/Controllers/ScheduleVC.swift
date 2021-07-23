//
//  ViewController.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/6/21.
//

import UIKit

class ScheduleVC: UIViewController{

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var scheduleSegmentedCOntrol: UISegmentedControl!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var noGamesLabel: UILabel!
    
    
    var gameArray: [Game] = []
    let userDefaults = UserDefaults.standard
    var scheduleManager = ScheduleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleManager.delegate = self
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI(){
        updateInitialUI()
        updateSegmentedControl()
        updateTableViewStyle()
        scheduleManager.perfomRequest(with: 0)
        checkToShowErrorLabel()
        scheduleTableView.reloadData()
    }
    
    func checkForEmptyArray(){
        if self.gameArray.isEmpty{
            self.scheduleTableView.isHidden = true
        } else{
            self.scheduleTableView.isHidden = false
        }
    }
    
    
    /*Note: - For Performing Requests, use slected segment index:
    -   0 => Games Played in the Past
    - 1 => Games Played Today
    - 2 => Upcomming Games
    */
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        scheduleManager.perfomRequest(with: sender.selectedSegmentIndex)
    }
}

//MARK: - UITableView

extension ScheduleVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currGame = self.gameArray[indexPath.row]
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        cell.setGameCell(currGame)
        return cell
    }
}


//MARK: - ScheduleManagerDelegate

extension ScheduleVC: ScheduleManagerDelegate{
    func didUpdateSchedule(_ scheduleManager: ScheduleManager, sortedSchedule: [Game]) {
        
        self.gameArray = sortedSchedule
        DispatchQueue.main.async {
            self.scheduleTableView.reloadData()
            self.checkForEmptyArray()
        }
    }
    
    func didFailWithError(_ scheduleManager: ScheduleManager, error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.errorLabel.text = "There was some error fetching data. \(error.localizedDescription)"
        }
    }
    
}

//MARK: - UI Update Functions
extension ScheduleVC{
    func updateInitialUI(){
        noGamesLabel.text = ""
        checkForEmptyArray()
    }
    
    func updateSegmentedControl(){
        self.scheduleSegmentedCOntrol.selectedSegmentIndex = 0
        self.scheduleSegmentedCOntrol.tintColor = UIColor.red
    }
    
    func updateTableViewStyle(){
        self.scheduleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    func checkToShowErrorLabel(){
        if gameArray.isEmpty{
            
        }
    }
}





