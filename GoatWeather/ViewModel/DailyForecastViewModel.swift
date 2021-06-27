//
//  DailyForecastViewModel.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import CoreLocation
import UIKit

protocol DailyForecastViewModelling: AnyObject {
    var weatherInfo: [WeatherInfoViewModelling]? { get }
    
    func getDailyForecast(with coordinates: CLLocationCoordinate2D)
}

class DailyForecastViewModel: NSObject, DailyForecastViewModelling {
    
    var weatherInfo: [WeatherInfoViewModelling]?
    
    private let service: WeatherServicing
    
    init(service: WeatherServicing) {
        self.service = service
        super.init()
        
        getDailyForecast(with: CLLocationCoordinate2D(latitude: 33.44, longitude: -94.04))
    }
    
    func getDailyForecast(with coordinates: CLLocationCoordinate2D) {
        service.getDailyForecast(with: coordinates) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    return
                }
                self.configure(response)
            break
            case .failure(_):
                //TODO @aldrich handle error
            break
            }
        }
    }
    
    private func configure(_ response: DailyForecastResponse) {
        weatherInfo = response.daily?.enumerated().map { WeatherInfoViewModel($1, index: $0) }
    }
}
