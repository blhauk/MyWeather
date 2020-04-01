import UIKit

func getLocalTime(epochTime: Double, offset: Double) -> String {
    let time =                  epochTime + offset
    let date =                  NSDate(timeIntervalSince1970: time )
    let dateFormatter =         DateFormatter()
    dateFormatter.timeStyle =   DateFormatter.Style.short
    dateFormatter.timeZone =    TimeZone(abbreviation: "UTC")
    let localTime =             dateFormatter.string(from: date as Date)
    return localTime
}

func getLocalDate(epochTime: Double, offset: Double) -> String {
    let time =                  epochTime + offset
    let date =                  NSDate(timeIntervalSince1970: time )
    let dateFormatter =         DateFormatter()
    dateFormatter.timeZone =    TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat =  "EEEE"
    var localDate =             dateFormatter.string(from: date as Date)
    print(localDate)
    
    dateFormatter.dateStyle =   .long
    localDate =             dateFormatter.string(from: date as Date)
    print(localDate)


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

let offset = -7.0*3600
var localGMTTime: Double
localGMTTime = 0
localGMTTime = NSDate().timeIntervalSince1970
print(localGMTTime)

let localTime  = getLocalTime(epochTime: localGMTTime, offset: offset)
print(localTime)

let localDate  = getLocalDate(epochTime: localGMTTime, offset: offset)
print(localDate)
