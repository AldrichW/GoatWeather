//
//  DailyForecastResponse.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import Foundation

struct DailyForecastResponse: Codable {
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let timezone_offset: Int?
    let daily: [DailyForecastModel]?
}

struct DailyForecastModel: Codable {
    let dt: Int?
    let temp: TemperatureModel?
    let weather: [WeatherModel]?
}

struct TemperatureModel: Codable {
    let day: Double?
    let min: Double?
    let max: Double?
}

struct WeatherModel: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

enum DailyForecastError: Error {

    case invalidURL
    case malformedJSON(DecodingError.Context)
    case serverError(Error)

    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Oops looks like this page doesn't exist"
        case .malformedJSON, .serverError:
            return "Looks like we're trying to send you the wrong thing. This is our fault, we're working to fix this."
        }
    }
}
