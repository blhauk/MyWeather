import Foundation

// Calgary
let latitude  = 51.053423
let longitude = -114.062589

// Adelaide
//let latitude  = -34.927428
//let longitude = 138.599899

let weatherAppid = "ce110c139ae40e4bc757dd1fa9502e5d"
let weatherUnits = "si"
let weatherURL = "https://api.darksky.net/forecast/"

//MARK: - JSON Weather structures
struct WeatherData: Codable {
    let currently:  CurrentConditions
    let daily:      DailyConditions
    let offset:     Double
}

struct CurrentConditions: Codable {
    let summary:                String
    let icon:                   String
    let temperature:            Double
    let humidity:               Double
    let apparentTemperature:    Double
}

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

//MARK: - Weather Data Model
struct WeatherModel {
    let summary:        String
    let summaryIcon:    String

    let temperature:    Double
    
    let feelsLike:      Double
    let humidity:       Double
    let lowTemp:        Double
    let highTemp:       Double
    
    let offset:         Double
    let sunrise:        Double
    let sunset:         Double
}

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

var sharedData = SharedData.sharedData

//MARK: - Fetch Forecast from LatLong
func fetchForecast(latitude: Double, longitude: Double)  {
    print("======================")
//    while !sharedData.locationDone {
//        print("fetchForecast: Waiting on locationDone")
//        usleep(100000) // Sleep for 0.1 sec
//    }
//    let lat = sharedData.latitude
//    let long = sharedData.longitude
    let lat = latitude
    let long = longitude
    let latlong = "/" + String(lat) + "," + String(long)
    let urlWeatherQuery = weatherURL + weatherAppid + latlong + "?units=\(weatherUnits)"
    
    print("fetchForecast urlWeatherQuery is  \(urlWeatherQuery)")
    
    sharedData.locationDone = false
    queryForecast(with: urlWeatherQuery)
}

func queryForecast(with urlString: String) {
    if let url = URL(string: urlString) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed  with error: \(error!)")
            }
            if let safeData = data {
                // if let weather = self.parseJSONForecast(safeData) {
                if let weather = parseJSONForecast(safeData) {
                    updateForecast(weather: weather)
                    //self.delegate?.didUpdateForecast(weather)
                } else {
                    print("Weather: parseJSON failed")
                }
            }
        }
        task.resume()
    } else {
        print("URL call failed")
    }
}

func parseJSONForecast(_ weatherData: Data) -> WeatherModel? {
    
    let decoder = JSONDecoder()
    print("======================")
    do { let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        
        let summary =       decodedData.currently.summary
        let summaryIcon =   decodedData.currently.icon
        let temperature =   decodedData.currently.temperature
        let feelsLike =     decodedData.currently.apparentTemperature
        let humidity =      decodedData.currently.humidity
        let lowTemp =       decodedData.daily.data[0].temperatureLow
        let highTemp =      decodedData.daily.data[0].temperatureHigh
        let offset =        decodedData.offset
        let sunrise =       decodedData.daily.data[0].sunriseTime
        let sunset =        decodedData.daily.data[0].sunsetTime
        
        let weatherResult = WeatherModel(
            summary:        summary,
            summaryIcon:    summaryIcon,
            temperature:    temperature,
            feelsLike:      feelsLike,
            humidity:       humidity,
            lowTemp:        lowTemp,
            highTemp:       highTemp,
            offset:         offset,
            sunrise:        sunrise,
            sunset:         sunset
        )
        print("parseJSONForecast: returning weatherResult")
        return weatherResult
    } catch {
        print("Inside parseJSONWeather catch")
        return nil
    }
}

func updateForecast(weather : WeatherModel) {
    print("======================")
    print("updateForecast: current temperature \(weather.temperature)")
}

fetchForecast(latitude: latitude, longitude: longitude)
