//
//  Game.swift
//  pocketNBA
//
//  Created by Hriday Chhabria on 7/7/21.
//

import Foundation
import UIKit

struct Game {
    let Status: String
    let DateTime: String?
    let AwayTeam: String
    let HomeTeam: String
    let Channel: String
    let AwayTeamScore: String
    let HomeTeamScore: String
    
    
    
    var dateAsObject: Date{ //Gets date in current timezone
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let isoDate = self.DateTime{
            if let curr = dateFormatter.date(from: isoDate) {
                var dateToReturn = curr
                dateToReturn.addTimeInterval(-14400)
              return dateToReturn
            }
        }
        return Date(timeIntervalSinceReferenceDate: -123456789.0)
    }
    
    var dateClassification: String{
        let calendar = Calendar.current
        let todaysComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: Date())
        let eventComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: self.dateAsObject)
        
        if((todaysComponents.month == eventComponents.month) && (todaysComponents.year == eventComponents.year) && todaysComponents.day == eventComponents.day){
            return "Today"
        }
        else if(self.dateAsObject < Date()){
            return "Past"
        }
        return "Upcomming"
        
       
    }
    
    var dateString: String{
        let eventDate = self.dateAsObject
        let calendar = Calendar.current
        let todayComponentes = calendar.dateComponents([.month, .day, .year, .hour, .weekday], from: eventDate)
        
        if calendar.isDateInToday(eventDate) {return "Tonight"}
        if calendar.isDateInTomorrow(eventDate) {return "Tomorrow"}
        if calendar.isDateInYesterday(eventDate) {return "Yesterday"}
        return "\(Helpers.getDayOfWeek(for: todayComponentes.weekday!)), \(Helpers.getMonth(for: todayComponentes.month!)) \(todayComponentes.day!)"
    }
}
