//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation
import CoreLocation

let locationAppid = "aOjpUyVev1Jt4GIGcZ34qFfx8bJt1DR5"
let cityLocationURL = "https://open.mapquestapi.com/geocoding/v1/address"
let latlongurl =  "https://open.mapquestapi.com/geocoding/v1/reverse"

let weatherAppid = "ce110c139ae40e4bc757dd1fa9502e5d"
let weatherUnits = "si"
let weatherURL = "https://api.darksky.net/forecast/"

var sharedData = SharedData.sharedData

protocol WeatherManagerDelegate {
    func didUpdateCityLocation(location: CityLocationModel)
    func didUpdateLatLongLocation(location: LatLongLocationModel)
    func didUpdateWeather(weather: WeatherModel)
    func didUpdateForecast(forecast: ForecastModel)
    func didFailWithError(error: Error)
}

//MARK: - WeatherManager struct
struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    //MARK: - Fetch LatLong from City Name
    func fetchLatlong(cityName: String){
        let urlLocationQuery  = cityLocationURL + "?key=\(locationAppid)" + "&location=\(cityName)"
        print("======================")
        print("fetchLatlong urlLocationQuery is  \(urlLocationQuery)")
        queryLatLong(with: urlLocationQuery)
        fetchWeather(latitude: sharedData.latitude, longitude: sharedData.longitude)
    }
    
    func queryLatLong(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let location = self.parseJSONCityLocation(safeData) {
                        updateCityLocation(location, sharedData)
                        self.delegate?.didUpdateCityLocation(location: location)
                    } else {
                        print("Location parseJSON failed")
                    }
                }
            }
            task.resume()
        } else {
            print("URL call failed")
        }
    }
    
    func parseJSONCityLocation(_ locationData: Data) -> CityLocationModel? {
        
        let decoder = JSONDecoder()
        
        do { let decodedData = try decoder.decode(CityDataLocation.self, from: locationData)
            
            let latitude =          decodedData.results[0].locations[0].latLng.lat
            let longitude =         decodedData.results[0].locations[0].latLng.lng
            let providedLocation =  decodedData.results[0].providedLocation.location
            let countryCode =       decodedData.results[0].locations[0].adminArea1
            let countryName =       decodedData.results[0].locations[0].adminArea3
            
            let locationResult = CityLocationModel(
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
    
    //MARK: - Fetch city name from lat/long
    func fetchCity(latitude: Double, longitude: Double){
        let latlong          = String(latitude) + ","  + String(longitude)
        let urlLocationQuery = latlongurl + "?key=\(locationAppid)" + "&location=\(latlong)"
        print("======================")
        print("fetchCity urlLocationQuery is  \(urlLocationQuery)")
        queryCity(with: urlLocationQuery)
    }
    
    func queryCity(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let location = self.parseJSONLatLong(safeData) {
                        print("======================")
                        print("queryCity: City is: \(location.city)")
                        print("queryCity: Country Code is: \(location.countryCode)")
                        updateLatLongLocation(location, sharedData)
                        self.delegate?.didUpdateLatLongLocation(location: location)
                    } else {
                        print("LatLong Location parseJSON failed")
                    }
                }
            }
            task.resume()
        } else {
            print("URL call failed")
        }
    }
    
    func parseJSONLatLong(_ locationData: Data) -> LatLongLocationModel? {
        let decoder = JSONDecoder()
        
        do { let decodedData = try decoder.decode(LatLongLocation.self, from: locationData)
            
            let city = decodedData.results[0].locations[0].adminArea5
            let countryCode = decodedData.results[0].locations[0].adminArea1
            
            let locationResult = LatLongLocationModel(
                city: city,
                countryCode: countryCode
            )
            
            return locationResult
        } catch {
            print("Inside parseJSONLocation catch")
            return nil
        }
    }
    
    //MARK: - Fetch Weather from LatLong
    func fetchWeather(latitude: Double, longitude: Double)  {
        print("======================")
        while !sharedData.locationDone {
            print("fetchWeather: Waiting on locationDone")
            usleep(100000) // Sleep for 0.1 sec
        }
        let lat = sharedData.latitude
        let long = sharedData.longitude
        let latlong = "/" + String(lat) + "," + String(long)
        let urlWeatherQuery = weatherURL + weatherAppid + latlong + "?units=\(weatherUnits)"
        
        print("fetchWeather urlWeatherQuery is  \(urlWeatherQuery)")
        
        sharedData.locationDone = false
        queryWeather(with: urlWeatherQuery)
    }

    func queryWeather(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed with error: \(error!)")
                }
                if let safeData = data {
                    if let weather = self.parseJSONWeather(safeData) {
                        updateWeather(weather)
                        self.delegate?.didUpdateWeather(weather: weather)
                    } else {
                        print("Weather: parseJSON failed")
                    }
                    if let forecast = self.parseJSONForecast(safeData) {
                        updateForecast(forecast: forecast)
                        self.delegate?.didUpdateForecast(forecast: forecast)
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

    func parseJSONWeather(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
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
            return weatherResult
        } catch {
            print("Inside parseJSONWeather catch")
            return nil
        }
    }
  
    func parseJSONForecast(_ forecastData: Data) -> ForecastModel? {
        
        let decoder = JSONDecoder()
        print("======================")
        do { let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
       
            var summary:     [String] = []
            var summaryIcon: [String] = []
            var appleIcon:   [String] = []
            var humidity:    [Double] = []
            var lowTemp:     [Double] = []
            var highTemp:    [Double] = []
            var offset:      [Double] = []
            var sunrise:     [Double] = []
            var sunset:      [Double] = []
            
            for i in 1...7 {
                let icon = decodedData.daily.data[i].icon
                let forecastAppleIcon = getAppleIcon(summaryIcon: icon)
                summary.append(decodedData.daily.data[i].summary)
                summaryIcon.append(decodedData.daily.data[i].icon)
                appleIcon.append(forecastAppleIcon)
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
                forecastAppleIcon:      appleIcon,
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
}

//MARK: - Update SharedData from CityLocationModel
func updateCityLocation(_ location: CityLocationModel, _ sharedData: SharedData) {
    print("======================")
    print("updateCityLocation: City is: \(location.providedLocation)")
    print("updateCityLocation: countryCode is: \(location.countryCode)")
    print("updateCityLocation: countryName is: \(location.countryName)")
    print("updateCityLocation: latitude is: \(location.latitude)")
    print("updateCityLocation: longitude is: \(location.longitude)")

    sharedData.providedLocation =   location.providedLocation
    sharedData.countryCode =        location.countryCode
    sharedData.countryName =        location.countryName
    sharedData.latitude =           location.latitude
    sharedData.longitude =          location.longitude
    sharedData.locationDone =       true
}

//MARK: - Update SharedData from LatLongLocationModel
func updateLatLongLocation(_ location: LatLongLocationModel, _ sharedData: SharedData){
    print("======================")
    print("updateLatLongLocation: City is: \(location.city)")
    print("updateLatLongLocation: countryCode is: \(location.countryCode)")
    sharedData.providedLocation = location.city
    sharedData.countryCode = location.countryCode
    sharedData.locationDone = true
}

//MARK: - Update SharedData from ForecastModel
func updateForecast(forecast: ForecastModel) {
    print("======================")

    sharedData.forecastSummary     = forecast.forecastSummary
    sharedData.forecastSummaryIcon = forecast.forecastSummaryIcon
    sharedData.forecastAppleIcon   = forecast.forecastAppleIcon
    
    sharedData.forecastHumidity = forecast.forecastHumidity
    sharedData.forecastLowTemp  = forecast.forecastLowTemp
    sharedData.forecastHighTemp = forecast.forecastHighTemp
        
    sharedData.forecastOffset  = forecast.forecastOffset
    sharedData.forecastSunrise = forecast.forecastSunrise
    sharedData.forecastSunset  = forecast.forecastSunset
    
    print("updateForecast: sharedData forecastSummaryIcon: \(sharedData.forecastSummaryIcon)")
    print("updateForecast: sharedData forecastAppleIcon: \(sharedData.forecastAppleIcon)")
    print("updateForecast: sharedData Daily low \(sharedData.forecastLowTemp)")
    print("updateForecast: sharedData Daily high \(sharedData.forecastHighTemp)")
    
}

//MARK: - Update SharedData from WeatherModel
func updateWeather(_ weather: WeatherModel) {
    
    sharedData.appleIcon = getAppleIcon(summaryIcon: weather.summaryIcon)
    print("")
    print("weather.summaryIcon: \(weather.summaryIcon)")
    print("sharedData.appleIcon: \(sharedData.appleIcon)")

    let offset = weather.offset * 3600
    
    let localGMTTime    = NSDate().timeIntervalSince1970
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
