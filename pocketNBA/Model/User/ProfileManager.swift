//
//  UserLocationManager.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/14/21.
//

import Foundation
import CoreLocation

protocol ProfileManagerDelegate {
    func didFindNeabyTeams(_ nearbyTeams: [NearbyTeams])
    
    func didFailWithError(_ error: Error)
}

struct ProfileManager {
    
    var delegate: ProfileManagerDelegate?

    let teamsByStadiumID: [String] = ["WAS","CHA","ATL","MIA","ORL","NY","PHI","BKN","BOS","TOR","CHI","CLE", "IND", "DET", "MIL", "MIN", "UTA", "OKC", "POR", "DEN", "MEM", "HOU", "NO", "SA", "DAL", "GS", "LAL", "PHO", "SAC"]

    func getNearbyTeams(for location: CLLocation){
        performRequest(for: location)
    }
    
    func performRequest(for userLocation: CLLocation){
        let stadiums = "https://fly.sportsdata.io/v3/nba/scores/json/Stadiums?key=e8fdcea5cae64ffcafcf90ce0c5d86ac"
        if let stadiumsURL = URL(string: stadiums){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: stadiumsURL) { urlData, response, error in
                if error != nil{
                    print(error!)
                }
                if let safeData = urlData{
                    if let stadiumAPIData = parseJSON(from: safeData){
                        let teams = sortStadiumsByProximity(to: userLocation, stadiumsInput: stadiumAPIData)
                        delegate?.didFindNeabyTeams(teams)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(from safeData: Data) -> [Stadium]?{
        let decoder = JSONDecoder()
        do {
            let stadiums = try decoder.decode([Stadium].self, from: safeData)
            return stadiums
        } catch  {
            print(error)
        }
        return nil
    }
    
    func sortStadiumsByProximity(to userLocation: CLLocation, stadiumsInput: [Stadium] ) -> [NearbyTeams] {
        
        var nearbyTeams: [NearbyTeams] = []
        
        for i in 0...28{
            let item = stadiumsInput[i]
            let coordinateOne = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let coordinateTwo = CLLocation(latitude: item.GeoLat!, longitude: item.GeoLong!)
            let distance = Double(coordinateOne.distance(from: coordinateTwo)) / 1609
            let teamKey = teamsByStadiumID[item.StadiumID-1]
            let stadium = NearbyTeams(StadiumId: item.StadiumID, DistanceFromUser: distance, Key: teamKey)
            if teamKey == "LAL"{
                nearbyTeams.append(NearbyTeams(StadiumId: item.StadiumID, DistanceFromUser: distance, Key: "LAC"))
            }
            nearbyTeams.append(stadium)
        }
        
        
        nearbyTeams = nearbyTeams.sorted(by: {$0.DistanceFromUser < $1.DistanceFromUser})
        return nearbyTeams
    }
    
    func getTeamListWithoutStadium() -> [NearbyTeams]{
        var temporaryTeamArray: [NearbyTeams] = []
        for team in teamsByStadiumID{
            let object = NearbyTeams(StadiumId: 100, DistanceFromUser: 100.0, Key: team)
            temporaryTeamArray.append(object)
        }
        temporaryTeamArray.insert(NearbyTeams(StadiumId: 100, DistanceFromUser: 100.0, Key: "LAC"), at: 0)
        temporaryTeamArray = temporaryTeamArray.sorted(by: {$0.Name < $1.Name})
        temporaryTeamArray.insert(NearbyTeams(StadiumId: 999, DistanceFromUser: 1000000, Key: "None"), at: 0)
        return temporaryTeamArray
    }
    
}

                
