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

class APIRequest {
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=1283240&APPID=0e9d7ae92aacb0d3419e9014e9466520")!
    var method = RequestType.GET
    var parameters = [String: String] ()
    
    public enum RequestType: String {
        case GET, POST, PUT,DELETE
    }
    
    
    func request(with baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

class APICalling {
    // create a method for calling api which is return a Observable
    func getForecast<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: Response = try JSONDecoder().decode(Response.self, from: data ?? Data())
                    observer.onNext( model.forecasts as! T)
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
        
        let request = apiRequest.request(with: apiRequest.baseURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                let model: Response = try JSONDecoder().decode(Response.self, from: data ?? Data())
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
