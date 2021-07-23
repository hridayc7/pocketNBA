//
//  Stadium.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/14/21.
//

import Foundation
import CoreLocation

struct NearbyTeams {
    let StadiumId: Int
    let DistanceFromUser: CLLocationDistance
    let Key: String
    var Name: String{
        switch self.Key {
        case "WAS":
            return "Washington Wizards"
        case "CHA":
            return"Charolette Hornets"
        case "ATL":
            return "Atlanta Hawks"
        case "MIA":
            return "Miami Heat"
        case "ORL":
            return "Orlando Magic"
        case "NY":
            return "New York Knicks"
        case "PHI":
            return "Philadelphia 76ers"
        case "BKN":
            return "Brooklyn Nets"
        case "TOR":
            return "Toronto Raptors"
        case "CHI":
            return "Chicago Bulls"
        case "CLE":
            return "Cleveland Cavaliers"
        case "IND":
            return "Indiana Pacers"
        case "DET":
            return "Detroit Pistons"
        case "MIL":
            return "Milwaukee Bucks"
        case "MIN":
            return "Minnesota Timberwolves"
        case "UTA":
            return "Utah Jazz"
        case "OKC":
            return "Oklahoma City Thunder"
        case "POR":
            return "Portland Trailblaizers"
        case "DEN":
            return "Denver Nuggets"
        case "MEM":
            return "Memphis Grizzlies"
        case "HOU":
            return "Houston Rockets"
        case "NO":
            return "New Orleans Pelicans"
        case "SA":
            return "San Antonio Spurs"
        case "DAL":
            return "Dallas Mavericks"
        case "GS":
            return "Golden State Warriors"
        case "LAL":
            return "Los Angeles Lakers"
        case "LAC":
            return "Los Angeles Clippers"
        case "PHO":
            return "Phoinex Suns"
        case "SAC":
            return "Sacramento Kings"
        case "BOS":
            return "Boston Celtics"
        default:
            return "No Team Selected"
        }
    }
}
