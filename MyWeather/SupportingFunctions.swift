//
//  SupportingFunctions.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-03-03.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

func getAppleIcon(summaryIcon: String) -> String{
    switch summaryIcon {
        case "clear-day" :
            return "sun.max"
        case "clear-night" :
            return "sun.max.fill"
        case "rain" :
             return "cloud.rain"
        case "snow" :
            return "cloud.snow"
        case "sleet" :
            return "cloud.sleet"
        case "wind" :
            return "wind"
        case "fog" :
            return "cloud.fog"
        case "cloudy" :
            return "cloud"
        case "partly-cloudy-day" :
            return "cloud.sun"
        case "partly-cloudy-night" :
            return "cloud.sun.fill"
        default :
            print("Case statement default: \(summaryIcon)")
            return "questionmark"
    }
}

func getLocalTime(epochTime: Double, offset: Double) -> String {
    let localTime =             epochTime + offset
    let date =                  NSDate(timeIntervalSince1970: localTime )
    let dateFormatter =         DateFormatter()
    dateFormatter.timeStyle =   DateFormatter.Style.short
    dateFormatter.timeZone =    TimeZone(abbreviation: "UTC")
    let localDate =             dateFormatter.string(from: date as Date)
    return localDate
}

func getLocalDate(epochTime: Double, offset: Double) -> String {
    let time =                  epochTime + offset
    let date =                  NSDate(timeIntervalSince1970: time )
    let dateFormatter =         DateFormatter()
    dateFormatter.dateStyle =   .long
    dateFormatter.timeZone =    TimeZone(abbreviation: "UTC")
    let localDate =             dateFormatter.string(from: date as Date)
    
    let commaIndex = localDate.firstIndex(of: ",")!
    let shortDate = localDate[localDate.startIndex..<commaIndex]
    
    let monthIndex = localDate.index(localDate.startIndex, offsetBy: 3)
    let monthStr = localDate[localDate.startIndex..<monthIndex]
    
    let dateIndex = shortDate.firstIndex(of: " ")!
    var dateStr = String(shortDate[shortDate.index(after: dateIndex)...])
    let dateInt = Int(dateStr)
    dateStr = String(format: "%2d", dateInt!)
    
    return String(monthStr + " " + dateStr)
}

func getLocalDay(epochTime: Double, offset: Double) -> String {
    let time =                  epochTime + offset
    let date =                  NSDate(timeIntervalSince1970: time )
    let dateFormatter =         DateFormatter()
    dateFormatter.timeZone =    TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat =  "EEEE"
    let localDay =             dateFormatter.string(from: date as Date)
    
    return localDay
}
