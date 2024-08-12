//
//  WeatherViewControllerPresenter.swift
//  ITAcademy_WeatherApp
//
//  Created by Влад Муравьев on 16.07.2024.
//

import UIKit

protocol IWeatherViewControllerPresenter {
    var backgroundColor: Bindable<UIColor> { get }
    func delegate(_ controller: IWeatherViewController)
    func loadWeather(for city: String?)
    func getDayCount() -> Int
    func switchForecast(for dayCount: ForecastType)
}

final class WeatherViewControllerPresenter: IWeatherViewControllerPresenter {
    
    private let weatherService: IWeatherNetworkService
    private let weatherManager: IWeatherManager
    
    weak var view: IWeatherViewController?
    
    let backgroundColor: Bindable<UIColor> = Bindable(.forestBlues)
    
    private var forecastCount = 3
    
    init(weatherService: IWeatherNetworkService, weatherManager: IWeatherManager) {
        self.weatherService = weatherService
        self.weatherManager = weatherManager
    }
    
    func delegate(_ controller: IWeatherViewController) {
        view = controller
    }
    
    func loadWeather(for city: String?) {
        
        guard let city else { return }
        
        weatherService.getForecast(city: city) { [weak self] current, forecast in
            
            guard let current,
                  let forecast else { return }
            
            DispatchQueue.main.async {
                
                let formattedCurrent = self?.formatWeather(current)
                let locationData = self?.formatLocationData(forecast)
                
                self?.getBackgroundColor(for: forecast)
                self?.view?.updateCurrentWeather(with: formattedCurrent)
                self?.view?.updateLocationData(with: locationData)
                self?.view?.updateDataSources(with: forecast)
                self?.view?.resetTextField()
                self?.view?.reloadCollections()
            }
        }
    }
    
    func getDayCount() -> Int {
        return forecastCount
    }
    
    func switchForecast(for dayCount: ForecastType) {
        
        forecastCount = dayCount.rawValue
        
        switch dayCount {
            
        case .three:
            view?.switchForecast(height: K.size.height.forecastCollapsed)
            view?.buttonSwitch(threeBool: true, sevenBool: false)
        case .seven:
            view?.switchForecast(height: K.size.height.forecastExpanded)
            view?.buttonSwitch(threeBool: false, sevenBool: true)
        }
    }
    
    private func getBackgroundColor(for weather: Forecast) {
        
        guard let weather = weather.data.first else { return }
        
        let current = Int(Date().timeIntervalSince1970)
        let sunset = weather.sunset_ts
        let sunrise = weather.sunrise_ts
        
        let dayLightLength = sunset - sunrise
        let quarter = dayLightLength / 4
        let morning = sunrise + quarter
        let evening = sunset - quarter
        
        switch current {
        case (sunrise - quarter)..<sunrise:
            backgroundColor.value = .turkishAqua
        case sunrise..<morning:
            backgroundColor.value = .androidGreen
        case morning..<evening:
            backgroundColor.value = .blueMartina
        case evening..<sunset:
            backgroundColor.value = .lavenderRose
        case sunset..<(sunset + quarter):
            backgroundColor.value = .magentaPurple
        default:
            backgroundColor.value = .forestBlues
        }
    }
    
    private func formatWeather(_ current: CurrentWeather) -> FormattedCurrentWeather? {
        
        guard let weather = current.data.first else { return nil }
        
        let tempInt = Int(weather.temp.rounded())
        
        let temp = "\(tempInt)°"
        let tuple = weatherManager.getWeatherImage(for: weather.weather.code, pod: weather.pod)
        
        return FormattedCurrentWeather(temp: temp, imageName: tuple.imageName, colors: tuple.colors)
    }
    
    private func formatLocationData(_ forecast: Forecast) -> FormattedForecastWeather? {
        
        guard let weather = forecast.data.first else { return nil }
        
        let name = forecast.city_name + " " + weatherManager.getCountryFlag(for: forecast.country_code)
        let date = weatherManager.formatTodaysDate(weather.datetime)
        
        return FormattedForecastWeather(cityName: name, date: date)
        
    }
    
}
