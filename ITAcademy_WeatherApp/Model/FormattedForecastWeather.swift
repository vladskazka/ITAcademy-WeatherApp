//
//  FormattedForecastWeather.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 30.07.2024.
//

import Foundation

final class FormattedForecastWeather {
    
    let cityName: String
    let date: String
    
    init(cityName: String, date: String) {
        self.cityName = cityName
        self.date = date
    }
}
