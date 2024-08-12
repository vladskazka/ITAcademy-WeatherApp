//
//  WeatherManager.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 28.06.2024.
//

import UIKit

protocol IWeatherManager {
    func formatTodaysDate(_ backendDate: String) -> String
    func formatForecastDate(_ backendDate: String, forIndex i: Int) -> String
    func getWeatherImage(for code: Int, pod: String) -> (imageName: String, colors: [UIColor])
    func getCountryFlag(for code: String) -> String
}

final class WeatherManager: IWeatherManager {
    
    func formatTodaysDate(_ backendDate: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let data = formatter.date(from: backendDate) {
            formatter.dateFormat = "E, MMM d"
            let dateString = formatter.string(from: data)
            return dateString
        } else {
            return backendDate
        }
    }
    
    func formatForecastDate(_ backendDate: String, forIndex i: Int) -> String {
        
        if i == 0 {
            return K.label.today
        } else if i == 1 {
            return K.label.tomorrow
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let data = formatter.date(from: backendDate) {
            formatter.dateFormat = "EEEE"
            let dateString = formatter.string(from: data)
            return dateString
        } else {
            return backendDate
        }
    }
    
    
    
    func getWeatherImage(for code: Int, pod: String = "d") -> (imageName: String, colors: [UIColor]) {
        
        switch code {
            
        case 200...202:
            return (K.images.rainstorm, K.palette.rainstorm)
        case 230...233:
            return (K.images.bolt, K.palette.bolt)
        case 300...302:
            return (K.images.drizzle, K.palette.drizzle)
        case 500...522, 900:
            return (K.images.rain, K.palette.rain)
        case 600...623:
            return (K.images.snow, K.palette.snow)
        case 700...751:
            return (K.images.fog, K.palette.fog)
        case 800:
            if pod == "d" {
                return (K.images.sun, K.palette.sun)
            } else {
                return (K.images.moon, K.palette.moon)
            }
        case 801...802:
            if pod == "d" {
                return (K.images.partialClouds, K.palette.partialClouds)
            } else {
                return (K.images.cloudsMoon, K.palette.cloudsMoon)
            }
        case 803...804:
            return (K.images.clouds, K.palette.clouds)
        default:
            return (K.images.errorForecast, K.palette.error)
        }
    }
    
    func getCountryFlag(for code: String) -> String {
        
        switch code {
        case "AR":
            return "🇦🇷"
        case "AU":
            return "🇦🇺"
        case "AT":
            return "🇦🇹"
        case "AZ":
            return "🇦🇿"
        case "BY":
            return "🇧🇾"
        case "BE":
            return "🇧🇪"
        case "BR":
            return "🇧🇷"
        case "CA":
            return "🇨🇦"
        case "CN":
            return "🇨🇳"
        case "DK":
            return "🇩🇰"
        case "EE":
            return "🇪🇪"
        case "FI":
            return "🇫🇮"
        case "FR":
            return "🇫🇷"
        case "DE":
            return "🇩🇪"
        case "GR":
            return "🇬🇷"
        case "HU":
            return "🇭🇺"
        case "IS":
            return "🇮🇸"
        case "IN":
            return "🇮🇳"
        case "IE":
            return "🇮🇪"
        case "IT":
            return "🇮🇹"
        case "JP":
            return "🇯🇵"
        case "KZ":
            return "🇰🇿"
        case "LV":
            return "🇱🇻"
        case "LT":
            return "🇱🇹"
        case "MX":
            return "🇲🇽"
        case "MN":
            return "🇲🇳"
        case "NL":
            return "🇳🇱"
        case "NZ":
            return "🇳🇿"
        case "NO":
            return "🇳🇴"
        case "PL":
            return "🇵🇱"
        case "PT":
            return "🇵🇹"
        case "RU":
            return "🇷🇺"
        case "RS":
            return "🇷🇸"
        case "ZA":
            return "🇿🇦"
        case "ES":
            return "🇪🇸"
        case "SE":
            return "🇸🇪"
        case "CH":
            return "🇨🇭"
        case "TH":
            return "🇹🇭"
        case "TR":
            return "🇹🇷"
        case "UA":
            return "🇺🇦"
        case "GB":
            return "🇬🇧"
        case "US":
            return "🇺🇸"
        default:
            return "🇺🇳"
        }
        
    }
}
