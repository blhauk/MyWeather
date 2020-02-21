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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print("textFieldShouldReturn City is: '\(searchTextField.text!)'")
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var city = searchTextField.text {
            city = cleanCityName(city)
            print("textFieldDidEndEditing City is: '\(city)'")
        }
    }
    
    func cleanCityName(_ city: String) -> String {
        var cleanCity  = city
        
        // Remove any trailing whitespace
        while cleanCity.last?.isWhitespace == true {
            cleanCity = String(city.dropLast())
        }
        
        // Make city 'URL Clean' (eg. replace spaces with "%20'
        cleanCity = cleanCity.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return cleanCity
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("didUpdateWeather")
    }
    
    func didFailWithError(error: Error) {
        print("didFailWithError")
    }
    
}
