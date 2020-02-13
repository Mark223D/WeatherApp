//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit



//struct Response: Decodable{
//    var result: [Forecast]
//
//    private enum CodingKeys: String, CodingKey {
//        case  result="list"
//    }
//
//}

struct Response: Decodable {
    let forecasts: [Forecast]?
    
    private enum CodingKeys: String, CodingKey {
        case forecasts = "list"
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var forecastssArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.forecasts)
        var forecasts = [Forecast]()
                while(!forecastssArray.isAtEnd) {
            forecasts.append(try forecastssArray.decode(Forecast.self))
        }
        self.forecasts = forecasts
    }
}


class Forecast: Codable{
    var info: WeatherInfo?
    var weathers: [Weather]?
    var wind: Wind?
    var weatherTime: String?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    enum CodingKeys: String, CodingKey {
        case info="main", weather="weather", wind="wind",weatherTime="dt_txt"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        info = try container.decode(WeatherInfo.self, forKey: .info)
        weatherTime = try container.decode(String.self, forKey: .weatherTime)
        var weathersArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.weather)
        var weathers = [Weather]()
        while(!weathersArray.isAtEnd) {
            weathers.append(try weathersArray.decode(Weather.self))
        }
        self.weathers = weathers
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(info, forKey: .info)
        try container.encode(weathers, forKey: .weather)
        try container.encode(wind, forKey: .wind)
        try container.encode(weatherTime, forKey: .weatherTime)

    }
    
    
    
    
}
class WeatherInfo: Codable {
    var temperature: CGFloat?
    var humidity: CGFloat?
    var feelsLike: CGFloat?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    
    enum CodingKeys: String, CodingKey {
        case temperature="temp", feelsLike="feels_like", humidity = "humidity"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try container.decode(CGFloat.self, forKey: .temperature)
        feelsLike = try container.decode(CGFloat.self, forKey: .feelsLike)
        humidity = try container.decode(CGFloat.self, forKey: .humidity)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(temperature, forKey: .temperature)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(feelsLike, forKey: .feelsLike)

    }
    
}
class Weather: Codable{
    var main: String?
    var description: String?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    enum CodingKeys: String, CodingKey {
        case main, description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        main = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(main, forKey: .main)
        try container.encode(description, forKey: .description)

    }
    
    
}


class Wind: Codable{
    var speed: CGFloat?
    var degree: CGFloat?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    enum CodingKeys: String, CodingKey {
        case speed, degree="deg"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(CGFloat.self, forKey: .speed)
        degree = try container.decode(CGFloat.self, forKey: .degree)
        
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(speed, forKey: .speed)
        try container.encode(degree, forKey: .degree)

    }
}


extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
