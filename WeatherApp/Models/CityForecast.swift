//
//  CityForecast.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/14/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation

class CityForecast: Codable {
    let forecasts: [CityWeather]?
    let count: Int?
    
    private enum CodingKeys: String, CodingKey {
        case forecasts = "list", count = "cnt"
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var forecastssArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.forecasts)
        var forecasts = [CityWeather]()
        while(!forecastssArray.isAtEnd) {
            let res = try forecastssArray.decode(CityWeather.self)
            forecasts.append(res)
        }
        self.forecasts = forecasts
        count = try container.decode(Int.self, forKey: .count)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(forecasts, forKey: .forecasts)
        
    }
    
}

class CityWeather: Codable {
    var info: WeatherInfo?
    var weathers: [Weather]?
    var wind: Wind?
    var city: String?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    enum CodingKeys: String, CodingKey {
        case info="main", weather="weather", wind="wind", city="name"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        info = try container.decode(WeatherInfo.self, forKey: .info)
        var weathersArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.weather)
        var weathers = [Weather]()
        while(!weathersArray.isAtEnd) {
            weathers.append(try weathersArray.decode(Weather.self))
        }
        self.weathers = weathers
        self.wind = try container.decode(Wind.self, forKey: .wind)
        city = try container.decode(String.self, forKey: .city)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(info, forKey: .info)
        try container.encode(weathers, forKey: .weather)
        try container.encode(wind, forKey: .wind)
        try container.encode(city, forKey: .city)
        
    }
}
