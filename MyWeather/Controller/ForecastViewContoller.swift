//
//  ForecastViewContoller.swift
//  MyWeather
//
//  Created by Blair Haukedal on 2020-03-02.
//  Copyright © 2020 blhauk. All rights reserved.
//

import Foundation
import UIKit

class ForecastViewContoller: UIViewController {
    var lowTemps:        [Double] = []
    var highTemps:       [Double] = []
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var day1DateLow: UILabel!
    @IBOutlet weak var day1DateHigh: UILabel!
    @IBOutlet weak var day2DateLow: UILabel!
    @IBOutlet weak var day2DateHigh: UILabel!
    @IBOutlet weak var day3DateLow: UILabel!
    @IBOutlet weak var day3DateHigh: UILabel!
    @IBOutlet weak var day4DateLow: UILabel!
    @IBOutlet weak var day4DateHigh: UILabel!
    @IBOutlet weak var day5DateLow: UILabel!
    @IBOutlet weak var day5DateHigh: UILabel!
    @IBOutlet weak var day6DateLow: UILabel!
    @IBOutlet weak var day6DateHigh: UILabel!
    @IBOutlet weak var day7DateLow: UILabel!
    @IBOutlet weak var day7DateHigh: UILabel!
    
    @IBOutlet weak var day1Low: UILabel!
    @IBOutlet weak var day1High: UILabel!
    @IBOutlet weak var day2Low: UILabel!
    @IBOutlet weak var day2High: UILabel!
    @IBOutlet weak var day3Low: UILabel!
    @IBOutlet weak var day3High: UILabel!
    @IBOutlet weak var day4Low: UILabel!
    @IBOutlet weak var day4High: UILabel!
    @IBOutlet weak var day5Low: UILabel!
    @IBOutlet weak var day5High: UILabel!
    @IBOutlet weak var day6Low: UILabel!
    @IBOutlet weak var day6High: UILabel!
    @IBOutlet weak var day7Low: UILabel!
    @IBOutlet weak var day7High: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var date: String
        var lowTemp: String
        var highTemp: String
        let city = sharedData.providedLocation
        let countryCode = sharedData.countryCode
        let countryName = countryCodes[countryCode]
        cityName.text = city + ", " + (countryName ?? "Unkown country")
        
        date = getLocalDate(epochTime: sharedData.forecastTime[0], offset: sharedData.forecastOffset[0])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[0])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[0])
        day1DateLow.text = date + " Low:"
        day1Low.text = lowTemp
        day1DateHigh.text = date + " High:"
        day1High.text = highTemp

        date = getLocalDate(epochTime: sharedData.forecastTime[1], offset: sharedData.forecastOffset[1])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[1])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[1])
        day2DateLow.text = date + " Low:"
        day2Low.text = lowTemp
        day2DateHigh.text = date + " High:"
        day2High.text = highTemp

        date = getLocalDate(epochTime: sharedData.forecastTime[2], offset: sharedData.forecastOffset[2])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[2])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[2])
        day3DateLow.text = date + " Low:"
        day3Low.text = lowTemp
        day3DateHigh.text = date + " High:"
        day3High.text = highTemp

        date = getLocalDate(epochTime: sharedData.forecastTime[3], offset: sharedData.forecastOffset[3])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[3])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[3])
        day4DateLow.text = date + " Low:"
        day4Low.text = lowTemp
        day4DateHigh.text = date + " High:"
        day4High.text = highTemp

        date = getLocalDate(epochTime: sharedData.forecastTime[4], offset: sharedData.forecastOffset[4])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[4])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[4])
        day5DateLow.text = date + " Low:"
        day5Low.text = lowTemp
        day5DateHigh.text = date + " High:"
        day5High.text = highTemp

        date = getLocalDate(epochTime: sharedData.forecastTime[5], offset: sharedData.forecastOffset[5])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[5])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[5])
        day6DateLow.text = date + " Low:"
        day6Low.text = lowTemp
        day6DateHigh.text = date + " High:"
        day6High.text = highTemp

        date = getLocalDate(epochTime: sharedData.forecastTime[6], offset: sharedData.forecastOffset[6])
        lowTemp =  String(format: "%3.1f°C", sharedData.forecastLowTemp[6])
        highTemp = String(format: "%3.1f°C", sharedData.forecastHighTemp[6])
        day7DateLow.text = date + " Low:"
        day7Low.text = lowTemp
        day7DateHigh.text = date + " High:"
        day7High.text = highTemp


    }
    
    @IBAction func currenConditionsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
