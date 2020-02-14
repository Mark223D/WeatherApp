//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit

struct ForecastResponse: Codable {
    let city: CityResponse?
    let forecasts: [Forecast]?
    
    private enum CodingKeys: String, CodingKey {
        case forecasts = "list", city="city"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var forecastssArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.forecasts)
        var forecasts = [Forecast]()
                while(!forecastssArray.isAtEnd) {
            forecasts.append(try forecastssArray.decode(Forecast.self))
        }
        self.forecasts = forecasts
        city = try container.decode(CityResponse.self, forKey: .city)
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(forecasts, forKey: .forecasts)

    }
}

class CityResponse: Codable {
    var id: Int?
    var name: String?
    var timezone: Int?
   
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    enum CodingKeys: String, CodingKey {
        case id, name, timezone,  info="main", weather="weather", wind="wind"
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        timezone = try container.decode(Int.self, forKey: .timezone)
       
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(id, forKey: .id)
        

    }
}
