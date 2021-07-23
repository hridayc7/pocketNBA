//
//  ScheduleJSON.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/7/21.
//

import Foundation

struct ScheduleJSON: Decodable {
    let Status: String
    let DateTime: String?
    let AwayTeam: String
    let HomeTeam: String
    let Channel: String?
    let AwayTeamScore: Int?
    let HomeTeamScore: Int?
}
