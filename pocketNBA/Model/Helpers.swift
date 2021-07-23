//
//  Helpers.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/20/21.
//

import Foundation

class Helpers {
    
    static func getMonth(for number: Int) -> String {
        switch number {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        default:
            return "December"
        }
    }
    
    static func getDayOfWeek(for int: Int) -> String{
        switch int {
          case 1:
            return ("Sunday")
                
          case 2:
            return ("Monday")
                
          case 3:
            return ("Tuesday")
                
          case 4:
            return ("Wednesday")
                
          case 5:
            return ("Thursday")
                
          case 6:
            return ("Friday")
                
          case 7:
            return ("Saturday")
                
          default:
            return ("Invalid day")
        }
    }
}
