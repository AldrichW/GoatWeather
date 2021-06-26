//
//  DailyForecastViewModel.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import UIKit

protocol DailyForecastViewModelling: AnyObject {
    var weatherInfo: [WeatherInfoViewModelling]? { get }
    
    func getDailyForecast()
}

class DailyForecastViewModel: NSObject, DailyForecastViewModelling {
    
    var weatherInfo: [WeatherInfoViewModelling]?
    
    func getDailyForecast() {
        // TODO: @aldrich make service call
    }
    
}
