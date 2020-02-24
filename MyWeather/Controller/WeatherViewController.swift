//
//  ViewController.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-02-20.
//  Copyright © 2020 blhauk. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var cityLabel: UILabel!
   
    @IBOutlet weak var currentTemp: UILabel!
    
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.delegate  = self
        searchTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        print("locationPressed City is: '\(searchTextField.text!)'")
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
            self.cityLabel.text = city
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
    func didUpdateLocation(location: LocationModel) {
        DispatchQueue.main.async {
            print("======================")
            print("didUpdateLocation: Latitude: \(location.latitude)")
            print("didUpdateLocation: Longitude: \(location.longitude)")
            print("didUpdateLocation: providedLocation: \(location.providedLocation)")
            print("didUpdateLocation: countryCode: \(location.countryCode)")
            print("didUpdateLocation: countryName: \(location.countryName)")
            print("didUpdateLocation: sharedData Latitude: \(sharedData.latitude)")
            print("didUpdateLocation: sharedData locationDone: \(sharedData.locationDone)")
            self.cityLabel.text = sharedData.providedLocation + ", " + (countryCodes[sharedData.countryCode] ?? "Unknown")
            self.latitude.text = String(format: "%3.3f", sharedData.latitude)
            self.longitude.text = String(format: "%3.3f", sharedData.longitude)
        }
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            print("======================")
            print("didUpdateWeather: Temperature: \(sharedData.temperature)")
            self.currentTemp.text = String(format: "%3.1f", sharedData.temperature)
        }
    }
    
    func didFailWithError(error: Error) {
        print("didFailWithError")
    }
    
}
