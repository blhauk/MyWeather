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

//MARK: - JSON Forecast structures
struct ForecastData: Codable {
    let offset: Double
    let daily:  DailyForecasts
}

struct DailyForecasts: Codable {
    let data: [ForecastDaily]
}

struct ForecastDaily: Codable {
    let summary:            String
    let icon:               String
    let humidity:           Double
    let temperatureLow:     Double
    let temperatureHigh:    Double
    let sunriseTime:        Double
    let sunsetTime:         Double

}

//MARK: - Forecast Data Model
struct ForecastModel {
    let forecastSummary:        [String]
    let forecastSummaryIcon:    [String]

    let forecastHumidity:       [Double]
    let forecastLowTemp:        [Double]
    let forecastHighTemp:       [Double]
    
    let forecastOffset:         [Double]
    let forecastSunrise:        [Double]
    let forecastSunset:         [Double]
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
    
    // Properties fom forecast call
    var forecastSummary:        [String] = []
    var forecastSummaryIcon:    [String] = []

    var forecastHumidity:       [Double] = []
    var forecastLowTemp:        [Double] = []
    var forecastHighTemp:       [Double] = []
    
    var forecastOffset:         [Double] = []
    var forecastSunrise:        [Double] = []
    var forecastSunset:         [Double] = []
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
                if let forecast = parseJSONForecast(safeData) {
                    updateForecast(forecast: forecast)
                    //self.delegate?.didUpdateForecast(forecast)
                } else {
                    print("parseJSONForecast failed")
                }
            }
        }
        task.resume()
    } else {
        print("queryForecast URL call failed")
    }
}

func parseJSONForecast(_ forecastData: Data) -> ForecastModel? {
    
    let decoder = JSONDecoder()
    print("======================")
    do { let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
   
        var summary:     [String] = []
        var summaryIcon: [String] = []
        var humidity:    [Double] = []
        var lowTemp:     [Double] = []
        var highTemp:    [Double] = []
        var offset:      [Double] = []
        var sunrise:     [Double] = []
        var sunset:      [Double] = []
        
        for i in 1...7 {
            summary.append(decodedData.daily.data[i].summary)
            summaryIcon.append(decodedData.daily.data[i].icon)
            humidity.append(decodedData.daily.data[i].humidity)
            lowTemp.append(decodedData.daily.data[i].temperatureLow)
            highTemp.append(decodedData.daily.data[i].temperatureHigh)
            offset.append(decodedData.offset)
            sunrise.append(decodedData.daily.data[i].sunriseTime)
            sunset.append(decodedData.daily.data[i].sunsetTime)
            
        }

        let forecastResult = ForecastModel(
            forecastSummary:        summary,
            forecastSummaryIcon:    summaryIcon,
            forecastHumidity:       humidity,
            forecastLowTemp:        lowTemp,
            forecastHighTemp:       highTemp,
            forecastOffset:         offset,
            forecastSunrise:        sunrise,
            forecastSunset:         sunset
        )
        print("parseJSONForecast: returning forecastResult")
        return forecastResult
    } catch {
        print("Inside parseJSONForecast catch")
        return nil
    }
}

func updateForecast(forecast: ForecastModel) {
    print("======================")

    sharedData.forecastSummary     = forecast.forecastSummary
    sharedData.forecastSummaryIcon = forecast.forecastSummaryIcon
    
    sharedData.forecastHumidity = forecast.forecastHumidity
    sharedData.forecastLowTemp  = forecast.forecastLowTemp
    sharedData.forecastHighTemp = forecast.forecastHighTemp
        
    sharedData.forecastOffset  = forecast.forecastOffset
    sharedData.forecastSunrise = forecast.forecastSunrise
    sharedData.forecastSunset  = forecast.forecastSunset
        
    print("updateForecast: ForecastModel Daily low \(forecast.forecastLowTemp)")
    print("updateForecast: sharedData Daily low \(sharedData.forecastLowTemp)")
    print("updateForecast: sharedData Daily high \(sharedData.forecastHighTemp)")
    
}

fetchForecast(latitude: latitude, longitude: longitude)
