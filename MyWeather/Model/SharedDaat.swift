//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

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
