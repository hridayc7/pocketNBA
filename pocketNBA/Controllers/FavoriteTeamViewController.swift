//
//  FavoriteTeamViewController.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/15/21.
//

import UIKit
import CoreLocation

class FavoriteTeamViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var profileManager = ProfileManager()
    var teams: [NearbyTeams] = []
    var filteredTeams: [NearbyTeams] = []
    var currentTeam: NearbyTeams = NearbyTeams(StadiumId: 999, DistanceFromUser: 1000000, Key: "None")
    
    @IBOutlet weak var teamPickerView: UIPickerView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var showNearbyTeams: UIButton!
    @IBOutlet weak var doneButtton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileManager.delegate = self
        locationManager.delegate = self
        teamPickerView.dataSource = self
        teamPickerView.delegate = self
        teams = profileManager.getTeamListWithoutStadium()
    }
    

    
}

//MARK: - UIPickerView Delegate

extension FavoriteTeamViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row].Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.teamImageView.image = UIImage(named: teams[row].Key)
        self.currentTeam = teams[row]
    }
    
}

//MARK: - Location Manager Delegate

extension FavoriteTeamViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last{
            profileManager.performRequest(for: currentLocation)
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func showNearbyTeamsPressed(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

}


//MARK: - Profile Manager Delegate

extension FavoriteTeamViewController: ProfileManagerDelegate{
    func didFindNeabyTeams(_ nearbyTeams: [NearbyTeams]) {
        
        
        
        for i in 0...3 {
            filteredTeams.append(nearbyTeams[i])
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "1", sender: self)
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        
    }
}

//MARK: - Segue
extension FavoriteTeamViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "1"{
            let destinationVC = segue.destination as! NearbyTeamsVC
            destinationVC.teams = self.filteredTeams
            destinationVC.currentTeam = self.currentTeam
        }
    }
    
    @IBAction func unwindToFavoritesVC(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
}

//MARK: - UIAlertController
extension FavoriteTeamViewController{
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        print(currentTeam.Key)
        
        var alertMessage = "Are you sure you want to select the \(currentTeam.Name) as your favorite team?"
        if currentTeam.Key == "None"{
            alertMessage = "Are you sure you don't want to select a favorite team?"
        }
        
        
        let alert = UIAlertController(title: "Confirm Favorite Team", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
                //Cancel Action
            }))
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        print("\(self.currentTeam.Name) selected as Favorite Team")
                                        Defaults.changeFavTeam(to: self.currentTeam.Key)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}



