//
//  StandingsJSON.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/13/21.
//

import Foundation

struct Standings: Decodable {
    let Season: Int
    let TeamID: Int
    let Key: String
    let Conference: String
    let Wins: Int
    let Losses: Int
    let Percentage: Double
}
