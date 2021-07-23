//
//  Defaults.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/20/21.
//

import Foundation
import UIKit

let userDefaults = UserDefaults.standard

class Defaults {
    static var favTeam = "None"
    
    static func changeFavTeam(to key: String){
        self.favTeam = key
        userDefaults.setValue(self.favTeam, forKey: "Fav")
    }
}


