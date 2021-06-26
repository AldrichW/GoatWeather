//
//  WeatherServiceRouter.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import Foundation

enum WeatherServiceRouter {
    case getDailyForecast
    
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
        case .getDailyForecast:
            let excludeList: String = "minutely,hourly,alerts"
            return [URLQueryItem(name: "appid", value: APISecrets.openWeatherAPIKey),
                    URLQueryItem(name: "exclude", value: excludeList)]
        }
    }
}

