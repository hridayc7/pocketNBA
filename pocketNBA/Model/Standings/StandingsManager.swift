//
//  StandingsManager.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/13/21.
//

import Foundation

protocol StandingsManagerDelegate {
    
    func displayStandings(_ teams: [Standings])
    
    func didFailWithError(err: Error)
}

struct StandingsManager {
    
    
    var delegate: StandingsManagerDelegate?
    let sourceURL: String = "https://fly.sportsdata.io/v3/nba/scores/json/Standings/2021?key=e8fdcea5cae64ffcafcf90ce0c5d86ac"
    
    func perfomRequest(for conferenceIndex: Int){
        if let url = URL(string: sourceURL){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if(error == nil){
                    if let safeData = data{
                        if let teamList = parseJSON(inpuData: safeData){
                            let conferenceStandings = splitTeamsByConference(teamList)
                            delegate?.displayStandings(conferenceStandings[conferenceIndex])
                        }
                    }
                } else{
                    delegate?.didFailWithError(err: error!)
                }
            }
            task.resume()
        }
    }
    

    func splitTeamsByConference(_ teamlist: [Standings]) -> [[Standings]]{
        var westernConference: [Standings] = []
        var easternConference: [Standings] = []
        
        for team in teamlist{
            if team.Conference == "Western"{
                westernConference.append(team)
            } else {
                easternConference.append(team)
            }
        }
        easternConference = easternConference.sorted(by: {$0.Wins > $1.Wins})
        westernConference = westernConference.sorted(by: {$0.Wins > $1.Wins})
        return[easternConference, westernConference]
    }
    
    
    func parseJSON(inpuData: Data) -> [Standings]?{
        let decoder = JSONDecoder()
        do {
            let decodedDataObject =  try decoder.decode([Standings].self, from: inpuData)
            return decodedDataObject
        } catch  {
            print(error)
        }
        return nil
    }
}
