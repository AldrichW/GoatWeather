//
//  WeatherInfoViewModel.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import UIKit

protocol WeatherInfoViewModelling: AnyObject {
    
    var index: Int { get }
    
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
    
    var index: Int
    
    var dayOfWeek: String?
    var date: String?
    var currentTemp: String?
    var highTemp: String?
    var lowTemp: String?
    
    var imageURL: String?
    
    var weatherDescription: String?
    
    init(index: Int,
         dayOfWeek: String?,
         date: String?,
         currentTemp: String?,
         highTemp: String?,
         lowTemp: String?,
         imageURL: String?,
         weatherDescription: String?) {
        self.index = index
        self.dayOfWeek = dayOfWeek
        self.date = date
        self.currentTemp = currentTemp
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.imageURL = imageURL
        self.weatherDescription = weatherDescription
        super.init()
    }
    
    convenience init(_ model: DailyForecastModel, index: Int) {
        let dayOfWeek = WeatherInfoViewModel.configureDayOfWeek(for: model.dt)
        let date = WeatherInfoViewModel.configureMonthAndDay(for: model.dt)
        let currentTemp = WeatherInfoViewModel.configureTempString(for: model.temp?.day)
        let highTemp = WeatherInfoViewModel.configureHighTempString(for: model.temp?.max)
        let lowTemp = WeatherInfoViewModel.configureLowTempString(for: model.temp?.min)
        let imageURL = WeatherInfoViewModel.configureImageURL(for: model.weather?.first?.icon)
        let description = model.weather?.first?.description
        self.init(index: index,
                  dayOfWeek: dayOfWeek,
                  date: date,
                  currentTemp: currentTemp,
                  highTemp: highTemp,
                  lowTemp: lowTemp,
                  imageURL: imageURL,
                  weatherDescription: description)
        
    }
    
    
    // MARK :- private temperature configuration methods
    private static func configureTempString(for temp:Double?) -> String {
        guard let temp = temp else {
            return "--\u{00B0}" // empty state
        }
        let rounded = round(temp)
        return "\(rounded)\u{00B0}"
    }
    
    private static func configureHighTempString(for temp:Double?) -> String {
        return "High " + configureTempString(for: temp)
    }
    
    private static func configureLowTempString(for temp:Double?) -> String {
        return "Low " + configureTempString(for: temp)
    }
    
    // MARK :- private image configuration methods
    private static func configureImageURL(for icon:String?) -> String {
        guard let icon = icon else {
            return ""
        }
        return "http://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    // MARK :- private date/time configuration methods
    private static func configureDayOfWeek(for timestamp:Int?) -> String {
        guard let timestamp = timestamp else {
            return "--"
        }
        let timeInterval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
    private static func configureMonthAndDay(for timestamp:Int?) -> String {
        guard let timestamp = timestamp else {
            return "--/--"
        }
        let timeInterval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        return dateFormatter.string(from: date)
    }
}
