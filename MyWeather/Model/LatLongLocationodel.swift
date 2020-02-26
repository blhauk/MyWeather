//
//  LatLongLocationodel.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-25.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

//MARK: - JSON Lat/Long Location Structures
struct LatLongLocation: Codable {
    let results: [LatLongResults]
}

struct LatLongResults: Codable {
    let locations: [LatLongLocations]
}

struct LatLongLocations: Codable {
    let adminArea5: String  // City Name
    let adminArea1: String  // Country Code
}

//MARK: - Lat/Long  Location Data Model
struct LatLongLocationModel {
    let city:           String
    let countryCode:    String
}
