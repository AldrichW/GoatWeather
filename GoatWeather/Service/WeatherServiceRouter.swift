//
//  WeatherServiceRouter.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import CoreLocation
import Foundation

enum WeatherServiceRouter {
    case getDailyForecast(CLLocationCoordinate2D)
    
    var scheme:String {
        "https"
    }
    
    var host: String {
        "api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .getDailyForecast:
            return "/data/2.5/onecall"
        }
    }
    
    var requestType: String {
        switch self {
        case .getDailyForecast:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getDailyForecast(let coordinates):
            let excludeList: String = "minutely,hourly,alerts"
            let units: String = "imperial"
            return [URLQueryItem(name: "appid", value: APISecrets.openWeatherAPIKey),
                    URLQueryItem(name: "exclude", value: excludeList),
                    URLQueryItem(name: "lat", value: String(coordinates.latitude)),
                    URLQueryItem(name: "lon", value: String(coordinates.longitude)),
                    URLQueryItem(name: "units", value: units)]
        }
    }
}

