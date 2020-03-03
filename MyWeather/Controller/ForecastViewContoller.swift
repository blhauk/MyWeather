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
    
    @IBOutlet weak var tomorrowLow: UILabel!
    @IBOutlet weak var tomorrowHigh: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tomorrowLow.text =  String(format: "%3.1f°C", sharedData.forecastLowTemp[0])
        tomorrowHigh.text =  String(format: "%3.1f°C", sharedData.forecastHighTemp[0])


    }
    
    @IBAction func currenConditionsPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
