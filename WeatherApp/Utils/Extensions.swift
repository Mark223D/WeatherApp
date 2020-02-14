//
//  Extensions.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/14/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
extension URL {
    
    func appending(_ queryItem: String, value: String?) -> URL {
        
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
       
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}

extension Notification.Name {
    static let updateWormTab = Notification.Name("updateWormTab")
}


extension UIView {
    func setGradientBackground(top: UIColor, bottom: UIColor) {
        let colorTop = top.cgColor
        let colorBottom = bottom.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension Date{
    func getDayDecorater()-> String{
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: self)
        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}
