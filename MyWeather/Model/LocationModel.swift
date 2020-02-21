//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

//MARK: - JSON Location Structures
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

//MARK: - Location Data Model
struct LocationModel {
    let latitude:           Double
    let longitude:          Double
    let providedLocation:   String
    let countryCode:        String
    let countryName:        String
}
