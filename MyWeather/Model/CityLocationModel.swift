//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation

//MARK: - JSON City Location Structures
struct CityDataLocation: Codable {
    let results: [CityResults]
}

struct CityResults: Codable {
    let providedLocation:   CityLocation
    let locations:          [CityLocations]
}

struct CityLocation: Codable {
    let location: String
}
struct CityLocations: Codable {
    let latLng:     CityLatLng
    let adminArea1: String // Country code - eg. CA for Canada
    let adminArea3: String // Country name - eg. Canada for CA
}

struct CityLatLng: Codable {
    let lat: Double
    let lng: Double
}

//MARK: - City Location Data Model
struct CityLocationModel {
    let latitude:           Double
    let longitude:          Double
    let providedLocation:   String
    let countryCode:        String
    let countryName:        String
}
