//
//  FormattedCurrentWeather.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 30.07.2024.
//

import UIKit

final class FormattedCurrentWeather {
    
    let temp: String
    let imageName: String
    let colors: [UIColor]
    
    init(temp: String, imageName: String, colors: [UIColor]) {
        self.temp = temp
        self.imageName = imageName
        self.colors = colors
    }
}
