//
//  WeatherDetail.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 28.06.2024.
//

import UIKit

// Objects for the UICollectionView with current weather conditions (wind speed, humidity, highest and lowest temp)

enum DetailType {
    case wind
    case tempHigh
    case humidity
    case tempLow
}

final class WeatherCondition {
    
    let type: DetailType
    let imageName: String
    var description: String
    let imageColors: [UIColor]
    
    init(type: DetailType, imageName: String, description: String, imageColors: [UIColor]) {
        self.type = type
        self.imageName = imageName
        self.description = description
        self.imageColors = imageColors
    }
}
