//
//  Forecast.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 01.07.2024.
//

import Foundation

struct Forecast: Codable {
    let city_name: String
    let country_code: String
    let data: [CityData]
}

struct CityData: Codable {
    let datetime: String
    let wind_spd: Double
    let rh: Int
    let max_temp: Double
    let min_temp: Double
    let weather: Weather
    let sunrise_ts: Int
    let sunset_ts: Int
}

struct Weather: Codable {
    let description: String
    let code: Int
}
