//
//  RequestModel.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation

class APIRequest {
    
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")!
    var method = RequestType.GET
    let locationManager = CLLocationManager()
    
    private var parameters = [
        "APPID": "0e9d7ae92aacb0d3419e9014e9466520",
        "units": "metric"
    ]
    
    public enum RequestType: String {
        case GET, POST, PUT,DELETE
    }
    
    
    func requestLocation(with baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL.appending("lat", value: "\(locationManager.location?.coordinate.latitude ?? 0.0 )")
            .appending("lon", value: "\(locationManager.location?.coordinate.longitude ?? 0.0 )")
            .appending("APPID", value: "0e9d7ae92aacb0d3419e9014e9466520")
            .appending("units", value: "metric"))
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func requestIDs(with baseURL: URL, and ids: [Int]) -> URLRequest {
        var str = "\(ids.first ?? 0)"
        
        if ids.count > 1 {
            for i in 1...ids.count-1 {
                str = "\(str),\(ids[i])"
            }
        }
        var request = URLRequest(url: baseURL
            .appending("id", value: "\(str)")
            .appending("APPID", value: "0e9d7ae92aacb0d3419e9014e9466520")
            .appending("units", value: "metric"))
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

}



class APICalling {
    
    //Get Forecast for current location

    func getForecast<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let url = URL(string: apiRequest.baseURL.absoluteString + "forecast") else { return Disposables.create() }
            let request = apiRequest.requestLocation(with: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: ForecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data ?? Data())
                    observer.onNext(model as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    
    func testCall(apiRequest: APIRequest){
        
        let request = apiRequest.requestLocation(with: apiRequest.baseURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    //Get Forecast for multiple cities
    func getCityForecast<T: Codable>(apiRequest: APIRequest, cities: [Int]) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let url = URL(string: apiRequest.baseURL.absoluteString + "group") else { return Disposables.create() }
            let request = apiRequest.requestIDs(with: url, and: cities)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: CityForecast = try JSONDecoder().decode(CityForecast.self, from: data ?? Data())
                    observer.onNext(model.forecasts as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    func testCallIDs(apiRequest: APIRequest, cities: [Int]){
           guard let url = URL(string: apiRequest.baseURL.absoluteString + "group") else { return }
           
           let request = apiRequest.requestIDs(with: url, and: cities)
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               do {
                   
                   if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                       print(json)
                   }
               } catch let error {
                   print(error)
               }
           }
           task.resume()
       }
}


