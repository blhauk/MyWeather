//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

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
