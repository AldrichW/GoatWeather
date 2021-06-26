//
//  WeatherService.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import CoreLocation
import Foundation

typealias DailyForecastResult = Result<DailyForecastResponse?, DailyForecastError>
typealias DailyForecastCompletion = (DailyForecastResult) -> ()

protocol WeatherServicing: AnyObject {
    func getDailyForecast(with coordinates: CLLocationCoordinate2D,
                          completion: @escaping DailyForecastCompletion)
    // ---- ADD NEW ENDPOINT CALLS BELOW ----
}

class WeatherService: NSObject, WeatherServicing {
    
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
        super.init()
    }
    
    // MARK :- CashStockServicing
    func getDailyForecast(with coordinates: CLLocationCoordinate2D,
                          completion: @escaping DailyForecastCompletion) {
        request(.getDailyForecast(coordinates), completion: completion)
    }
    
    // MARK :- Private
    private func request<T:Codable>(_ router: WeatherServiceRouter, completion: @escaping (Result<T?, DailyForecastError>)->()) {
        
        var urlComponents = URLComponents()
        urlComponents .scheme = router.scheme
        urlComponents .host = router.host
        urlComponents .path = router.path
        urlComponents.queryItems = router.parameters
        
        guard let url = urlComponents.url else {
            fatalError("Invalid URL: \(String(describing: urlComponents.string))")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.requestType
        
        let task = session
            .dataTask(with: request) { [weak self] (data, response, error) in
                if let error = error {
                    completion(.failure(.serverError(error)))
                }
                
                if let data = data {
                    do {
                        let response = try self?.decoder.decode(T.self, from: data)
                        completion(.success(response))
                    }
                    catch let DecodingError.dataCorrupted(context) {
                            debugPrint(context)
                            completion(.failure(.malformedJSON(context)))
                        } catch let DecodingError.keyNotFound(key, context) {
                            debugPrint("Key '\(key)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                            completion(.failure(.malformedJSON(context)))
                        } catch let DecodingError.valueNotFound(value, context) {
                            debugPrint("Value '\(value)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                            completion(.failure(.malformedJSON(context)))
                        } catch let DecodingError.typeMismatch(type, context)  {
                            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                            completion(.failure(.malformedJSON(context)))
                        } catch {
                            print("error: ", error)
                        }
                }
            }
        
        task.resume()
    }
}
