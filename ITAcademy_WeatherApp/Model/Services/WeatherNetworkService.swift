//
//  WeatherNetworkService.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 01.07.2024.
//

import Foundation

private extension String {
    static let baseURL = "https://api.weatherbit.io/v2.0"
        static let apiKey = "3897016bb1be4db6b1ff6463dd15623e"
//    static let apiKey = "133a05bd3a9d4d0a8d46de8c59f93cbc"
}

private enum Endpoint: String {
    case current = "/current?city="
    case forecast = "/forecast/daily?city="
}

private enum RequestType: String {
    case get = "GET"
}

protocol IWeatherNetworkService {
    func getForecast(city: String, completion: @escaping (CurrentWeather?, Forecast?) -> Void)
}

final class WeatherNetworkService: IWeatherNetworkService {
    
    func getForecast(city: String, completion: @escaping (CurrentWeather?, Forecast?) -> Void) {
        
        let queue = DispatchQueue(label: "queue", qos: .userInteractive, attributes: .concurrent)
        let group = DispatchGroup()
        
        var forecastData: (current: CurrentWeather?, forecast: Forecast?)
        
        // Current weather
        let first = DispatchWorkItem {
            self.fetchWeather(requestType: .get, endpoint: .current, city: city) { [weak self] data in
                
                guard let data,
                      let self else {
                    group.leave()
                    return
                }
                
                forecastData.current = self.parseForecast(data: data)
                
                group.leave()
            }
        }
        
        // Forecast
        let second = DispatchWorkItem {
            self.fetchWeather(requestType: .get, endpoint: .forecast, city: city) { [weak self] data in
                
                guard let data,
                      let self else {
                    group.leave()
                    return
                }
                
                forecastData.forecast = self.parseForecast(data: data)
                
                group.leave()
            }
        }
        
        group.enter()
        queue.async(execute: first)
        
        group.enter()
        queue.async(execute: second)
        
        group.notify(queue: queue) {
            completion(forecastData.current, forecastData.forecast)
        }
    }
    
    private func fetchWeather(requestType: RequestType, endpoint: Endpoint, city: String, completion: @escaping (Data?) -> Void) {
        
        guard let url = URL(string: .baseURL + endpoint.rawValue + city + "&key=" + .apiKey) else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil {
                completion(data)
            } else {
                completion(nil)
            }
        }
        .resume()
    }
    
    private func parseForecast<T: Codable>(data: Data) -> T? {
        
        let decoder = JSONDecoder()
        
        guard let jsonObject = try? decoder.decode(T.self, from: data) else { return nil }
        
        return jsonObject
    }
}
