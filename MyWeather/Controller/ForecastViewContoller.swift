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
    
    @IBOutlet weak var day1Date: UILabel!
    @IBOutlet weak var day2Date: UILabel!
    @IBOutlet weak var day3Date: UILabel!
    @IBOutlet weak var day4Date: UILabel!
    @IBOutlet weak var day5Date: UILabel!
    @IBOutlet weak var day6Date: UILabel!
    @IBOutlet weak var day7Date: UILabel!
    
    @IBOutlet weak var day1Low: UILabel!
    @IBOutlet weak var day1High: UILabel!
    @IBOutlet weak var day1Hum: UILabel!
    
    @IBOutlet weak var day2Low: UILabel!
    @IBOutlet weak var day2High: UILabel!
    @IBOutlet weak var day2Hum: UILabel!
    
    @IBOutlet weak var day3Low: UILabel!
    @IBOutlet weak var day3High: UILabel!
    @IBOutlet weak var day3Hum: UILabel!
    
    @IBOutlet weak var day4Low: UILabel!
    @IBOutlet weak var day4High: UILabel!
    @IBOutlet weak var day4Hum: UILabel!
    
    @IBOutlet weak var day5Low: UILabel!
    @IBOutlet weak var day5High: UILabel!
    @IBOutlet weak var day5Hum: UILabel!
    
    @IBOutlet weak var day6Low: UILabel!
    @IBOutlet weak var day6High: UILabel!
    @IBOutlet weak var day6Hum: UILabel!
    
    @IBOutlet weak var day7Low: UILabel!
    @IBOutlet weak var day7High: UILabel!
    @IBOutlet weak var day7Hum: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var days:      [String] = []
        var lowTemps:   [String] = []
        var highTemps:  [String] = []
        var humidities: [String] = []

        let city = sharedData.providedLocation
        let countryCode = sharedData.countryCode
        let countryName = countryCodes[countryCode]
        cityName.text = city + ", " + (countryName ?? "Unkown country")
        
        var day:  String
        for i in 0...6 {
            day = getLocalDay(epochTime: sharedData.forecastTime[i], offset: sharedData.forecastOffset[i])
            days.append(day)
            lowTemps.append(String(format: "%3.1f°C", sharedData.forecastLowTemp[i]))
            highTemps.append(String(format: "%3.1f°C", sharedData.forecastHighTemp[i]))
            humidities.append(String(format: "%3.0f%%", sharedData.forecastHumidity[i]*100))
        }

        day1Date.text = days[0]
        day1Low.text =  lowTemps[0]
        day1High.text = highTemps[0]
        day1Hum.text =  humidities[0]

        day2Date.text = days[1]
        day2Low.text =  lowTemps[1]
        day2High.text = highTemps[1]
        day2Hum.text =  humidities[1]

        day3Date.text = days[2]
        day3Low.text =  lowTemps[2]
        day3High.text = highTemps[2]
        day3Hum.text =  humidities[2]

        day4Date.text = days[3]
        day4Low.text =  lowTemps[3]
        day4High.text = highTemps[3]
        day4Hum.text =  humidities[3]

        day5Date.text = days[4]
        day5Low.text =  lowTemps[4]
        day5High.text = highTemps[4]
        day5Hum.text =  humidities[4]

        day6Date.text = days[5]
        day6Low.text =  lowTemps[5]
        day6High.text = highTemps[5]
        day6Hum.text =  humidities[5]

        day7Date.text = days[6]
        day7Low.text =  lowTemps[6]
        day7High.text = highTemps[6]
        day7Hum.text =  humidities[6]


    }
    
    @IBAction func currenConditionsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
