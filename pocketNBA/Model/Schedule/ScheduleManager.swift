//
//  StatsManager.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/7/21.
//

import Foundation

protocol ScheduleManagerDelegate {
    func didUpdateSchedule(_ scheduleManager: ScheduleManager, sortedSchedule: [Game])
    func didFailWithError(_ scheduleManager: ScheduleManager, error: Error)
}


struct ScheduleManager {
    
    var delegate: ScheduleManagerDelegate?
    
    let userDefaults = UserDefaults.standard
    
    let sourceUrl = "https://fly.sportsdata.io/v3/nba/scores/json/Games/2021POST?key=e8fdcea5cae64ffcafcf90ce0c5d86ac"
    
    let timeDictionary = [
        1: "Past",
        2: "Today",
        3: "Upcomming"
    ]
    
    /// This function is responsible for performing a urlSession Task from the schedule manager's source URL. Additionally, this method asks its delegate to work with the [Game] array.
    func perfomRequest(with identifier: Int){
        //Creates a url from a url string
        if let url = URL(string: sourceUrl){
            //Creates a urlSession object
            let urlSession = URLSession(configuration: .default)
            //adds a task to the url session oibject
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                
                //handles potential error
                if(error != nil){
                    delegate?.didFailWithError(self, error: error!)
                    return
                }
                
                //gets data from URL
                if let safeData = data{
                    if let decodedDataArray = parseJSON(obtainedData: safeData){
                        let allGames = createGames(from: decodedDataArray)
                        let sortedGames = sortGames(allGames)
                        let finalGameSet = [highlightFavoriteTeam(sortedGames[0]), highlightFavoriteTeam(sortedGames[1]), highlightFavoriteTeam(sortedGames[2])]
    
                        delegate?.didUpdateSchedule(self, sortedSchedule: finalGameSet[identifier])
                    }
                }
            }
            task.resume()
        }
    }
    
    /// This function is responsible for taking in the data returned by the API, and parsing the JSON into a Schedule Object.
    /// - Parameter obtainedData: Safedata in a JSON format.
    /// - Returns: An Array of Game objects(decoded Json converted to Game Objects)
    func parseJSON(obtainedData: Data) -> [ScheduleJSON]?{
        let decoder = JSONDecoder()
        do {
            let decodedSchedule =  try decoder.decode([ScheduleJSON].self, from: obtainedData)
            return decodedSchedule
        }catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
    
    /// This function takes in a decodedObject and returns an array of Games objects i.e [Game]
    /// - Parameter decodedObject: The decoded JSON object array (All scheduled games)
    /// - Returns: an array containing all the games in the nba schedule
    func createGames(from decodedObject: [ScheduleJSON]) -> [Game]{
        var games: [Game] = []
        for obj in decodedObject{
            let game = createGameObject(inputData: obj)
            games.append(game)
        }
        return games
    }
    
    
    /// This function creates a Game object from the decoded JSON by making use of the Game data model
    /// - Parameter inputData: The decoded JSON object
    /// - Returns: a Game Object
    func createGameObject(inputData: ScheduleJSON) -> Game{
        
        var homeTeamScoreString = "-"
        if let homeScore = inputData.HomeTeamScore {
            homeTeamScoreString = "\(homeScore*2)"
        }
        
        var awayTeamScoreString = "-"
        if let awayScore = inputData.AwayTeamScore{
            awayTeamScoreString = "\(awayScore*2)"
        }
        
        let game = Game(Status: inputData.Status, DateTime: inputData.DateTime ?? "-", AwayTeam: inputData.AwayTeam, HomeTeam: inputData.HomeTeam, Channel: inputData.Channel ?? "-", AwayTeamScore: awayTeamScoreString, HomeTeamScore: homeTeamScoreString)
        
        return game
    }
    
    func sortGames(_ allGames: [Game]) -> [[Game]]{
        var pastGames: [Game] = []
        var todayGames: [Game] = []
        var upcommingGames: [Game] = []
        for game in allGames {
            if(game.Status != "Canceled"){
                switch game.dateClassification {
                case "Today":
                    todayGames.append(game)
                case "Past":
                    pastGames.append(game)
                default:
                    upcommingGames.append(game)
                }
            }
            
        }
        return [pastGames.reversed(), todayGames, upcommingGames]
    }
    
   func highlightFavoriteTeam(_ array: [Game]) -> [Game]{
        
        let favoriteTeamKey = userDefaults.string(forKey: "Fav")
        var games = array
        var index = 0
        
        for game in games{
            if game.HomeTeam == favoriteTeamKey || game.AwayTeam == favoriteTeamKey{
                if (game.dateString == "Today" || game.dateString == "Tomorrow" || game.dateString == "Yesterday"){
                    let tempGame = games.first
                    games[0] = games[index]
                    games[index] = tempGame!
                }
            }
            index += 1
        }
        
        return games
    }
    
}
