//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

//MARK: - JSON Weather structures
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
