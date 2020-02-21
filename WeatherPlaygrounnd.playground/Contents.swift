import Foundation
//Pick a City
// Calgary
//let lat = "51.0447"
//let long = "-114.0719"
// Adelaide
//let lat = "34.9285"
//let long = "138.6007"
let city = "Canada"

func cleanCityName(_ city: String) -> String {
    var cleanCity  = city
    
    // Remove any traling whitespace
    while cleanCity.last?.isWhitespace == true {
        cleanCity = String(city.dropLast())
    }
    
    // Encode spaces to "%20"
    cleanCity = cleanCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return cleanCity
}

let location = cleanCityName(city)

//MARK: - Shared data  - a work in progress  - do I really need a singleton?
class SharedData {
    // An attempt to make a singleton for sharing
    static let sharedData = SharedData()
    
    // Properties from location call
    var providedLocation:   String = ""
    var latitude:           Double = 1
    var longitude:          Double = 2
    var countryCode:        String = ""
    var countryName:        String = "foobaz"
    var locationDone:       Bool   = false
    
    // Properties fom weather  call
    var temperature:        Double = 3
    var summary:            String = ""
    var summaryIcon:        String = "foobar"
    var appleIcon:          String = "booboo"
    var feelsLike:          Double = 4
    var lowTemp:            Double = 5
    var highTemp:           Double = 6
    var humidity:           Double = 7
    var localTime:          String = ""
    var localSunriseTime:   String = ""
    var localSunsetTime:    String = ""
    var weatherDone:        Bool   = false
    
    

}

//MARK: - Location model
struct LocationModel {
    let latitude:           Double
    let longitude:          Double
    let providedLocation:   String
    let countryCode:        String
    let countryName:        String
}

//MARK: - Location JSON data structures
struct LocationData: Codable {
    let results: [Results]
}

struct Results: Codable {
    let providedLocation:   Location
    let locations:          [Locations]
}

struct Location: Codable {
    let location: String
}
struct Locations: Codable {
    let latLng:     LatLng
    let adminArea1: String // Country code - eg. CA for Canada
    let adminArea3: String // Countr name - eg. Canada for CA
}

struct LatLng: Codable {
    let lat: Double
    let lng: Double
}

//MARK: - Weather model
struct WeatherModel {
    let time:           Double
    let offset:         Double
    let temperature:    Double
    let summary:        String
    let summaryIcon:    String
    let feelsLike:      Double
    let lowTemp:        Double
    let highTemp:       Double
    let humidity:       Double
    let sunrise:        Double
    let sunset:         Double
}

//MARK: - Weather JSON data structures
struct WeatherData: Codable {
    let currently:  CurrentConditions
    let daily:      DailyConditions
    let offset:     Double
}

struct CurrentConditions: Codable {
    let time:                   Double
    let summary:                String
    let icon:                   String
    let temperature:            Double
    let humidity:               Double
    let apparentTemperature:    Double
}

//FIXME: JSON Parser pukes on DailyCondtions
struct DailyConditions: Codable {
    let summary:    String
    let icon:       String
    let data:       [DailyData]
}

struct DailyData: Codable {
    let sunriseTime:        Double
    let sunsetTime:         Double
    let temperatureHigh:    Double
    let temperatureLow:     Double
}

//MARK: - Supporting Global functions
func getLocalTime(epochTime: Double, offset: Double) -> String {
    let localTime =             epochTime + offset
    let date =                  NSDate(timeIntervalSince1970: localTime )
    let dateFormatter =         DateFormatter()
    dateFormatter.timeStyle =   DateFormatter.Style.short
    dateFormatter.timeZone =    TimeZone(abbreviation: "UTC")
    let localDate =             dateFormatter.string(from: date as Date)
    return localDate
}

//MARK: - Supporting Locaton functions
func parseJSONLocation(_ locationData: Data) -> LocationModel? {
    
    let decoder = JSONDecoder()
    
    do { let decodedData = try decoder.decode(LocationData.self, from: locationData)
        
        let latitude =          decodedData.results[0].locations[0].latLng.lat
        let longitude =         decodedData.results[0].locations[0].latLng.lng
        let providedLocation =  decodedData.results[0].providedLocation.location
        let countryCode =       decodedData.results[0].locations[0].adminArea1
        let countryName =       decodedData.results[0].locations[0].adminArea3

        let locationResult = LocationModel(
            latitude:           latitude,
            longitude:          longitude,
            providedLocation:   providedLocation,
            countryCode:        countryCode,
            countryName:        countryName
        )
        
        return locationResult
    } catch {
        print("Inside parseJSONLocation catch")
        return nil
    }
}

func updateLocation(_ location: LocationModel, _ sharedData: SharedData) {
    sharedData.latitude =           location.latitude
    sharedData.longitude =          location.longitude
    sharedData.providedLocation =   location.providedLocation
    sharedData.countryCode =        location.countryCode
    sharedData.countryName =        location.countryName
    sharedData.locationDone =       true
}

//MARK: - Supporting Weather functions
func parseJSONWeather(_ weatherData: Data) -> WeatherModel? {
    
    let decoder = JSONDecoder()
    
    do { let decodedData = try decoder.decode(WeatherData.self, from: weatherData)

        
        let time =          decodedData.currently.time
        let offset =        decodedData.offset
        let temperature =   decodedData.currently.temperature
        let summary =       decodedData.currently.summary
        let summaryIcon =   decodedData.currently.icon
        let feelsLike =     decodedData.currently.apparentTemperature
        let lowTemp =       decodedData.daily.data[0].temperatureLow
        let highTemp =      decodedData.daily.data[0].temperatureHigh
        let humidity =      decodedData.currently.humidity
        let sunrise =       decodedData.daily.data[0].sunriseTime
        let sunset =        decodedData.daily.data[0].sunsetTime

        let weatherResult = WeatherModel(
            time:           time,
            offset:         offset,
            temperature:    temperature,
            summary:        summary,
            summaryIcon:    summaryIcon,
            feelsLike:      feelsLike,
            lowTemp:        lowTemp,
            highTemp:       highTemp,
            humidity:       humidity,
            sunrise:        sunrise,
            sunset:         sunset
        )
        
        return weatherResult
    } catch {
        print("Inside parseJSONWeather catch")
        return nil
    }
}

func updateWeather(_ weather: WeatherModel) {
    
    switch weather.summaryIcon {
    case "clear-day" :
        sharedData.appleIcon = "sun.max"
    case "clear-night" :
        sharedData.appleIcon = "sun.max.fill"
    case "rain" :
        sharedData.appleIcon = "cloud.rain"
    case "snow" :
        sharedData.appleIcon = "cloud.snow"
    case "sleet" :
        sharedData.appleIcon = "cloud.sleet"
    case "wind" :
        sharedData.appleIcon = "wind"
    case "fog" :
        sharedData.appleIcon = "cloud.fog"
    case "cloudy" :
        sharedData.appleIcon = "cloud"
    case "partly-cloudy-day" :
        sharedData.appleIcon = "cloud.sun"
    case "partly-cloudy-night" :
        sharedData.appleIcon = "cloud.sun.fill"
    default :
        print("Case statement default: \(weather.summaryIcon)")
        sharedData.appleIcon = "questionmark"
    }
    
    let offset = weather.offset * 3600
    
    let localGMTTime    = weather.time
    let localGMTSunrise = weather.sunrise
    let localGMTSunset  = weather.sunset
    
    let localTime           = getLocalTime(epochTime: localGMTTime, offset: offset)
    let localSunriseTime    = getLocalTime(epochTime: localGMTSunrise, offset: offset)
    let localSunsetTime     = getLocalTime(epochTime: localGMTSunset, offset: offset)
    
    sharedData.temperature      = weather.temperature
    sharedData.summary          = weather.summary
    sharedData.summaryIcon      = weather.summaryIcon
    sharedData.feelsLike        = weather.feelsLike
    sharedData.humidity         = weather.humidity
    sharedData.highTemp         = weather.highTemp
    sharedData.lowTemp          = weather.lowTemp
    sharedData.localTime        = localTime
    sharedData.localSunriseTime = localSunriseTime
    sharedData.localSunsetTime  = localSunsetTime
    
    sharedData.weatherDone      = true
    
}

//MARK: - Main entry point = determine lat/longs from queried "location" (first line of code as "city")
var sharedData = SharedData.sharedData
print("Location Entry Point")
let urlLocationQuery = "http://open.mapquestapi.com/geocoding/v1/address"
let locationAppid = "aOjpUyVev1Jt4GIGcZ34qFfx8bJt1DR5"
let urlLocationString = urlLocationQuery + "?key=\(locationAppid)" + "&location=\(location)"
print("urlLocationString: \(urlLocationString)")

if let url = URL(string: urlLocationString) {
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("Failed with error: \(error!)")
        }
        if let safeData = data {
            if let location = parseJSONLocation(safeData) {
                updateLocation(location, sharedData)
            } else {
                print("Location parseJSON failed")
            }
        }
    }
    task.resume()
} else {
    print("URL call failed")
}
print("Location Exit point")
print()

//MARK: - Weather entry point



print("Weather Entry point")
while !sharedData.locationDone {
    print("Waiting on locationDone")
    usleep(100000) // Sleep for 0.1 sec
}
let urlWeatherQuery = "https://api.darksky.net/forecast/"
let weatherAppid = "ce110c139ae40e4bc757dd1fa9502e5d"
let units = "si"

let lat = sharedData.latitude
let long = sharedData.longitude
let latlong = "/" + String(lat) + "," + String(long)
let urlWeatherString = urlWeatherQuery + weatherAppid + latlong + "?units=\(units)"
print("urlWeatherString: \(urlWeatherString)")

if let url = URL(string: urlWeatherString) {
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("Failed with error: \(error!)")
        }
        if let safeData = data {
            if let weather = parseJSONWeather(safeData) {
                updateWeather(weather)
            } else {
                print("Weather: parseJSON failed")
            }
        }
    }
    task.resume()
} else {
    print("URL call failed")
}
sharedData.locationDone = false
print("Weather Exit point")
print()


while !sharedData.weatherDone {
    print("Waiting on weatherDone")
    usleep(100000) // Sleep for 0.1 sec
}
// Location provided data
print()
print("Location provided data")
print("main: sharedData providedLocation: \(sharedData.providedLocation)")
print("main: sharedData countryCode: \(sharedData.countryCode)")
print("main: sharedData countryName: \(sharedData.countryName)")
print("main: sharedData latitude: \(sharedData.latitude)")
print("main: sharedData longitude: \(sharedData.longitude)")

// Weather provided data
print()
print("Weather provided data")
print("main: sharedData temperature: \(sharedData.temperature)")
print("main: sharedData summary: \(sharedData.summary)")
print("main: sharedData summaryIcon: \(sharedData.summaryIcon)")
print("main: sharedData appleIcon: \(sharedData.appleIcon)")
print("main: sharedData feelsLike: \(sharedData.feelsLike)")
print("main: sharedData humidity: \(sharedData.humidity)")
print("main: sharedData lowTemp: \(sharedData.lowTemp)")
print("main: sharedData highTemp: \(sharedData.highTemp)")
print("main: sharedData localTime: \(sharedData.localTime)")
print("main: sharedData localSunriseTime: \(sharedData.localSunriseTime)")
print("main: sharedData localSunsetTime: \(sharedData.localSunsetTime)")
sharedData.weatherDone = false


