//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit

@IBDesignable
class ForecastView: UIView {
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet weak var circleView: Circle!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        
        let nib = UINib(nibName: "ForecastView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        
    }
    
    func setModel(_ model: Forecast){
        self.circleView.updateColors(top: .yellow, bottom: .darkYellow, size: self.circleView.size ?? self.circleView.defaultSize)
        
        let feelsLikeC = (5/9) * ((model.info?.feelsLike ?? 0) - 32)
        let tempC = (5/9) * ((model.info?.temperature ?? 0) - 32)

        self.feelsLikeLabel.text = "\(Int(feelsLikeC))°C"
        self.humidityLabel.text = "\(Int(model.info?.humidity ?? 0))%"
        self.temperatureLabel.text = "\(Int(tempC))°C"
        
    }
    
    
}
