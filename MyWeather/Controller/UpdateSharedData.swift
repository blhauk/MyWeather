//
//  UpdateSharedData.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-03-01.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

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
    
    sharedData.forecastTime    = forecast.forecastTime
    sharedData.forecastOffset  = forecast.forecastOffset
    sharedData.forecastSunrise = forecast.forecastSunrise
    sharedData.forecastSunset  = forecast.forecastSunset
    
    sharedData.forecastDone = true
    
    print("updateForecast: sharedData forecastSummaryIcon: \(sharedData.forecastSummaryIcon)")
    print("updateForecast: sharedData forecastAppleIcon: \(sharedData.forecastAppleIcon)")
    print("updateForecast: sharedData Daily low \(sharedData.forecastLowTemp)")
    print("updateForecast: sharedData Daily high \(sharedData.forecastHighTemp)")
    
}

//MARK: - Update SharedData from WeatherModel
func updateWeather(_ weather: WeatherModel) {
    
    sharedData.appleIcon = getAppleIcon(summaryIcon: weather.summaryIcon)
    print("======================")
    print("updateWeather: weather.summaryIcon: \(weather.summaryIcon)")
    print("updateWeather: sharedData.appleIcon: \(sharedData.appleIcon)")

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
