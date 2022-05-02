//
//  CurrentWeatherData.swift
//  MyWeatherCity
//
//  Created by Serhii Palamarchuk on 01.05.2022.
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
    }
}

struct Sys: Codable {
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
}
