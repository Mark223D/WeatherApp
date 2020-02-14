//
//  AlertHandler.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import UIKit

class AlertHandler {
    
    private let alertTitle: String = "WeatherApp"
    private var alertStyle: UIAlertController.Style = .alert
    private var animated: Bool = true
    
    init() {
        print("De-Initializing Alert Handler")

    }
    
    func showAlert(on vc:UIViewController, with message: String, and actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: self.alertTitle, message: message, preferredStyle: alertStyle)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        vc.present(alertController, animated: animated, completion: nil)
    }
    
    
    deinit {
        print("De-Initializing Alert Handler")
    }
    
}

