//
//  WeatherInfoViewModel.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import UIKit

protocol WeatherInfoViewModelling: AnyObject {
    // left side Info
    var dayOfWeek: String? { get }
    var date: String? { get }
    
    // right side Info
    var currentTemp: String? { get }
    var highTemp: String? { get }
    var lowTemp: String? { get }
    
    // image
    var imageURL: String? { get }
    
    // detail pagge
    var weatherDescription: String? { get }
}

class WeatherInfoViewModel: NSObject, WeatherInfoViewModelling {
    
    var dayOfWeek: String?
    var date: String?
    
    var currentTemp: String?
    var highTemp: String?
    var lowTemp: String?
    
    var imageURL: String?
    
    var weatherDescription: String?
    
    init(dayOfWeek: String?,
         date: String?,
         currentTemp: String?,
         highTemp: String?,
         lowTemp: String?,
         imageURL: String?,
         weatherDescription: String?) {
        self.dayOfWeek = dayOfWeek
        self.date = date
        self.currentTemp = currentTemp
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.imageURL = imageURL
        self.weatherDescription = weatherDescription
        super.init()
    }

}
