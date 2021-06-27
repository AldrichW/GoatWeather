//
//  DailyForecastViewModel.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import CoreLocation
import UIKit

enum DailyForecastFeedState {
    case empty
    case error(DailyForecastError)
    case feed
}

protocol DailyForecastPresenting:AnyObject {
    func feedShouldUpdate(with state: DailyForecastFeedState)
}

protocol DailyForecastViewModelling: AnyObject {
    var presenter: DailyForecastPresenting? { get set }
    var weatherInfo: [WeatherInfoViewModelling]? { get }
    
    func getDailyForecast(with coordinates: CLLocationCoordinate2D)
}

class DailyForecastViewModel: NSObject, DailyForecastViewModelling {
    
    weak var presenter: DailyForecastPresenting?
    
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
                    self.presenter?.feedShouldUpdate(with: .empty)
                    return
                }
                self.configure(response)
                self.presenter?.feedShouldUpdate(with: .feed)
            break
            case .failure(let error):
                self.presenter?.feedShouldUpdate(with: .error(error))
            break
            }
        }
    }
    
    private func configure(_ response: DailyForecastResponse) {
        weatherInfo = response.daily?.enumerated().map { WeatherInfoViewModel($1, index: $0) }
    }
}
