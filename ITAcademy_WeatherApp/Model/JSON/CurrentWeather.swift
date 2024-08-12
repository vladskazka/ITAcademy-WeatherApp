//
//  CurrentWeather.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 06.07.2024.
//

import Foundation

struct CurrentWeather: Codable {
    let data: [CurrentData]
}

struct CurrentData: Codable {
    let rh: Int
    let temp: Double
    let ts: Int
    let sunrise: String
    let sunset: String
    let timezone: String
    let ob_time: String
    let pod: String // part of the day, "d" = day, "n" = night
    let weather: Weather // Weather defined in Forecast
}
