//
//  ForecastModel.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-29.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

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
    let forecastAppleIcon:      [String]

    let forecastHumidity:       [Double]
    let forecastLowTemp:        [Double]
    let forecastHighTemp:       [Double]
    
    let forecastOffset:         [Double]
    let forecastSunrise:        [Double]
    let forecastSunset:         [Double]
}
