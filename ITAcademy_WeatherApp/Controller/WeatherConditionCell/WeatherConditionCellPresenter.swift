//
//  DetailCollectionViewCellPresenter.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 25.07.2024.
//

import UIKit

protocol IWeatherConditionCellPresenter {
    func getWeatherCondition(at index: Int) -> WeatherCondition
    func getWeatherArrayCount() -> Int
    func updateArray(with weather: CityData?)
}

final class WeatherConditionCellPresenter: IWeatherConditionCellPresenter {
    
    private lazy var weatherCondition: [WeatherCondition] = [
        
        WeatherCondition(
            type: .wind,
            imageName: K.images.wind, 
            description: getDescription(for: .wind),
            imageColors: [
                .gray,
                .orange
            ]
        ),
        WeatherCondition(
            type: .tempHigh,
            imageName: K.images.thermometerHigh,
            description: getDescription(for: .tempHigh),
            imageColors: [
                .red,
                .black.withAlphaComponent(0.5)
            ]
        ),
        WeatherCondition(
            type: .humidity,
            imageName: K.images.humidity,
            description: getDescription(for: .humidity),
            imageColors: [
                .systemBlue,
                .darkGray
            ]
        ),
        WeatherCondition(
            type: .tempLow,
            imageName: K.images.thermometerLow,
            description: getDescription(for: .tempLow),
            imageColors: [
                .systemCyan,
                .black.withAlphaComponent(0.5)
            ]
        )
    ]
    
    func getWeatherCondition(at index: Int) -> WeatherCondition {
        return weatherCondition[index]
    }
    
    func getWeatherArrayCount() -> Int {
        return weatherCondition.count
    }
    
    func updateArray(with weather: CityData?) {
        
        for item in weatherCondition {
            
            let newDescription = getDescription(for: item.type, with: weather)
            item.description = newDescription
        }
        
    }
    
    private func getDescription(for type: DetailType, with weather: CityData? = nil) -> String {
        
        var value = K.label.dashes
        
        switch type {
            
        case .wind:
            if let newWindSpeed = weather?.wind_spd.rounded() {
                value = String(Int(newWindSpeed))
            }
            return "\(value) mph"
            
        case .tempHigh:
            if let newMaxTemp = weather?.max_temp.rounded() {
                value = String(Int(newMaxTemp))
            }
            return "H: \(value)°"
            
        case .humidity:
            if let newHumidity = weather?.rh {
                value = String(newHumidity)
            }
            return "\(value) %"
            
        case .tempLow:
            if let newMinTemp = weather?.min_temp.rounded() {
                value = String(Int(newMinTemp))
            }
            return "L: \(value)°"
        }
    }
}
