//
//  City.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation

class City: Codable {
    var id: Int?
    var name: String?
    var country: String?
    var selected:Bool?
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    private enum CodingKeys: String, CodingKey {
        case name, id, country
    }
    
    init(id: Int, name: String, country: String) {
        self.id = id
        self.name = name
        self.country = country
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)
        try container.encode(id, forKey: .id)
        
    }
}

class CityJSON: Codable {
    var id: Int?
    var name: String?
    var country: String?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    enum CodingKeys: String, CodingKey {
        case id, name, country
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)
        try container.encode(id, forKey: .id)
        
    }
    
}
