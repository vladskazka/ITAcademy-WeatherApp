//
//  TableVIewCellPresenter.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 25.07.2024.
//

import UIKit

protocol ITableViewCellPresenter {
    func getForecast(at index: Int) -> DailyForecast
    func updateForecastArray(for forecast: Forecast?)
}

final class TableViewCellPresenter: ITableViewCellPresenter {
    
    private let weatherManager: IWeatherManager
    
    private var forecastArray: [DailyForecast] = []
    
    init(weatherManager: WeatherManager) {
        self.weatherManager = weatherManager
        updateForecastArray(for: nil)
    }
    
    func getForecast(at index: Int) -> DailyForecast {
        return forecastArray[index]
    }
    
    func updateForecastArray(for forecast: Forecast?){
        
        forecastArray = []
                
        var dayOfWeek = K.label.failed
        var temp = K.label.dashes
        var imageName = K.images.error
        var colors = K.palette.error
        
        for i in 0..<ForecastType.seven.rawValue {
            
            if let forecast {
                
                let data = forecast.data[i]
                
                dayOfWeek = weatherManager.formatForecastDate(data.datetime, forIndex: i)
                temp = String(Int(data.max_temp.rounded()))
                imageName = weatherManager.getWeatherImage(for: data.weather.code, pod: K.label.defaultPod).imageName
                colors = weatherManager.getWeatherImage(for: data.weather.code, pod: K.label.defaultPod).colors
            }
            
            let forecastObject = DailyForecast(
                dayOfWeek: dayOfWeek,
                temperature: "\(temp)°",
                imageName: imageName,
                imageColors: colors
            )
            
            forecastArray.append(forecastObject)
        }
    }
    
}
