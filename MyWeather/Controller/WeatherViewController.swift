//
//  ViewController.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    @IBOutlet weak var currentTemp: UILabel!
    
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var sunRise: UILabel!
    @IBOutlet weak var sunSet: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var tomorrowLow: UILabel!
    @IBOutlet weak var tomorrowHigh: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()

        
        weatherManager.delegate  = self
        searchTextField.delegate = self
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        print("searchPressed City is: '\(searchTextField.text!)'")
        //Causes the view (or one of its embedded text fields) to resign the first responder status
        searchTextField.endEditing(true)
    }
  
    // Asks the delegate if editing should stop in the specified text field
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // Tells the delegate that editing stopped for the specified text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var city = searchTextField.text {
            city = cleanCityName(city)
            weatherManager.fetchLatlong(cityName: city)
        }
        searchTextField.text = ""
    }
    
    // Asks the delegate if the text field should process the pressing of the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // Ensure City Name has no trailing blanks, blanks are escaped and word capitalized
    func cleanCityName(_ city: String) -> String {
        var cleanCity  = city
        
        // Remove any trailing whitespace
        while cleanCity.last?.isWhitespace == true {
            cleanCity = String(city.dropLast())
        }
        
        // Make city 'URL Clean' (eg. replace spaces with "%20'
        cleanCity = cleanCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // Capitalize each word (eg. Las Vegas)
        return cleanCity.capitalized
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateLatLongLocation(location: LatLongLocationModel) {
        DispatchQueue.main.async {
            print("======================")
            print("didUpdateLatLongLocation: City: \(location.city)")
            print("didUpdateLatLongLocation: sharedData Latitude: \(sharedData.latitude)")
            print("didUpdateLatLongLocation: sharedData locationDone: \(sharedData.locationDone)")
            self.latitude.text = String(format: "%3.3f", sharedData.latitude)
            self.longitude.text = String(format: "%3.3f", sharedData.longitude)
        }
    }
    
    func didUpdateCityLocation(location: CityLocationModel) {
        DispatchQueue.main.async {
            print("======================")
            print("didUpdateCityLocation: Latitude: \(sharedData.latitude)")
            print("didUpdateCityLocation: Longitude: \(sharedData.longitude)")
            print("didUpdateCityLocation: providedLocation: \(sharedData.providedLocation)")
            print("didUpdateCityLocation: countryCode: \(sharedData.countryCode)")
            print("didUpdateCityLocation: countryName: \(sharedData.countryName)")
            print("didUpdateCityLocation: sharedData Latitude: \(sharedData.latitude)")
            print("didUpdateCityLocation: sharedData locationDone: \(sharedData.locationDone)")
            self.latitude.text = String(format: "%3.3f", sharedData.latitude)
            self.longitude.text = String(format: "%3.3f", sharedData.longitude)
        }
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            print("======================")
            print("didUpdateWeather: Temperature: \(sharedData.temperature)")
            print("didUpdateWeather: Summary: \(sharedData.summary)")
            print("didUpdateWeather: Summaryicon: \(sharedData.summaryIcon)")
            print("didUpdateWeather: Appleicon: \(sharedData.appleIcon)")
            print("didUpdateWeather: Localtime: \(sharedData.localTime)")
            print("didUpdateWeather: Humidity: \(sharedData.humidity)")
            
            self.cityLabel.text = sharedData.providedLocation + ", " + (countryCodes[sharedData.countryCode] ?? "Unknown")
            
            
            self.summary.text         = sharedData.summary
            self.conditionImage.image = UIImage(systemName: sharedData.appleIcon)
            
            self.currentTemp.text     = String(format: "%3.1f", sharedData.temperature)
            
            self.feelsLike.text =    String(format: "%3.1f°C", sharedData.feelsLike)
            self.humidity.text  =    String(format: "%3.0f%%", sharedData.humidity*100)
            self.lowTemp.text   =    String(format: "%3.1f°C", sharedData.lowTemp)
            self.highTemp.text  =    String(format: "%3.1f°C", sharedData.highTemp)
            self.localTime.text =    sharedData.localTime
            self.sunRise.text   =    sharedData.localSunriseTime
            self.sunSet.text    =    sharedData.localSunsetTime
            while !sharedData.forecastDone {
                print("didUpdateWeather: Waiting on forecastDone")
                usleep(100000) // Sleep for 0.1 sec
            }
            sharedData.forecastDone  = false
            print("didUpdateWeather: sharedData.forecastLowTemp: \(sharedData.forecastLowTemp)")
            self.tomorrowLow.text =  String(format: "%3.1f°C", sharedData.forecastLowTemp[0])
            self.tomorrowHigh.text = String(format: "%3.1f°C", sharedData.forecastHighTemp[0])
        }
    }
    
    func didUpdateForecast(forecast: ForecastModel) {
        print("inside didUpdateForecast")
    }
    
    func didFailWithError(error: Error) {
        print("didFailWithError")
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            print("")
            print("======================")
            print("LocationManagerDelegate: Latitude is: \(lat)")
            print("LocationManagerDelegate: Longitude is: \(long)")
            sharedData.latitude = lat
            sharedData.longitude = long
            weatherManager.fetchCity(latitude: lat, longitude: long)
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
