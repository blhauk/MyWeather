//
//  File.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation
let locationAppid = "aOjpUyVev1Jt4GIGcZ34qFfx8bJt1DR5"
let urlLocation = "https://open.mapquestapi.com/geocoding/v1/address"
var sharedData = SharedData.sharedData

protocol WeatherManagerDelegate {
    func didUpdateLocation(location: LocationModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    func fetchLatlong(cityName: String){
        let urlLocationQuery  = urlLocation + "?key=\(locationAppid)" + "&location=\(cityName)"
        print("fetchWeather urlLocationQuery is  \(urlLocationQuery)")
        queryLatLong(with: urlLocationQuery)
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
                    if let location = self.parseJSONLocation(safeData) {
                        updateLocation(location, sharedData)
                        self.delegate?.didUpdateLocation(location: location)
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
    
    func parseJSONLocation(_ locationData: Data) -> LocationModel? {
        
        let decoder = JSONDecoder()
        
        do { let decodedData = try decoder.decode(LocationData.self, from: locationData)
            
            let latitude =          decodedData.results[0].locations[0].latLng.lat
            let longitude =         decodedData.results[0].locations[0].latLng.lng
            let providedLocation =  decodedData.results[0].providedLocation.location
            let countryCode =       decodedData.results[0].locations[0].adminArea1
            let countryName =       decodedData.results[0].locations[0].adminArea3

            let locationResult = LocationModel(
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
}

func updateLocation(_ location: LocationModel, _ sharedData: SharedData) {
    sharedData.latitude =           location.latitude
    sharedData.longitude =          location.longitude
    sharedData.providedLocation =   location.providedLocation
    sharedData.countryCode =        location.countryCode
    sharedData.countryName =        location.countryName
    sharedData.locationDone =       true
}

