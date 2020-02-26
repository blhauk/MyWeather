import UIKit

// Toronto
// let latitude =  43.654
// let longitude = -79.387

// Calgary
// let latitude =  51.053
// let longitude = -114.063

// Adelaide  - returns "5000" for city
// let latitude =  -34.927
// let longitude = 138.600

// London, England
 let latitude =  51.057
 let longitude = -0.128

// London, Ontario
//let latitude =  43.572
//let longitude = -79.713

let locationAppid = "aOjpUyVev1Jt4GIGcZ34qFfx8bJt1DR5"
let latlongurl =  "https://open.mapquestapi.com/geocoding/v1/reverse"

let url =  "https://open.mapquestapi.com/geocoding/v1/reverse?key=aOjpUyVev1Jt4GIGcZ34qFfx8bJt1DR5&location=51.053423,-114.062589"

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

func queryCity(with urlString: String) {
     if let url = URL(string: urlString) {
         let session = URLSession(configuration: .default)
         
         let task = session.dataTask(with: url) { (data, response, error) in
             if error != nil {
                 //self.delegate?.didFailWithError(error: error!)
                 return
             }
             
             if let safeData = data {
                 if let location = parseJSONLatLong(safeData) {
                    print("City is: \(location.city)")
                    print("Country Code is: \(location.countryCode)")
                     //updateLocation(location, sharedData)
                     //self.delegate?.didUpdateLocation(location: location)
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

func fetchCity(latitude: Double, longitude: Double){
    let latlong          = String(latitude) + ","  + String(longitude)
    let urlLocationQuery = latlongurl + "?key=\(locationAppid)" + "&location=\(latlong)"
    print("fetchCity urlLocationQuery is  \(urlLocationQuery)")
    queryCity(with: urlLocationQuery)
}

func parseJSONLatLong(_ locationData: Data) -> LatLongLocationModel? {
    print("Inside parseJSONLatLong")
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

fetchCity(latitude: latitude, longitude: longitude)
//let city = LatLongLocationModel.city
//print(LatLongLocationModel.city)
