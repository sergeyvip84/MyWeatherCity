//
//  CurrentWeather.swift
//  MyWeatherCity
//
//  Created by Serhii Palamarchuk on 01.05.2022.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    let conditionCode: Int
    var systemIconNameString: [String] {
        switch conditionCode {
        case 200...232: return ["cloud.bolt.rain.fill", "thunderstorm"]
        case 300...321: return ["cloud.drizzle.fill", "sunandcloud"]
        case 500...531: return ["cloud.rain.fill", "rain"]
        case 600...622: return ["cloud.snow.fill", "snow"]
        case 701...781: return ["smoke.fill", "fog"]
        case 800: return ["sun.max.fill", "sun"]
        case 801...804: return ["cloud.fill", "cloudly"]
        default: return ["nosign", "background"]
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
