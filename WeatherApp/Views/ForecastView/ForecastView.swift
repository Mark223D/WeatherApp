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
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
                
        self.feelsLikeLabel.text = "\(Int(model.info?.feelsLike ?? 0))°C"
        self.humidityLabel.text = "\(Int(model.info?.humidity ?? 0))%"
        self.tempMinLabel.text = "\(Int(model.info?.tempMin ?? 0))°C"
        self.tempMaxLabel.text = "\(Int(model.info?.tempMax ?? 0))°C"
        self.descriptionLabel.text = (model.weathers?.first?.description ?? "").capitalized

        self.handleCircleColor(model)
        
        
    }
    func handleCircleColor(_ model: Forecast){
        var colorTop: UIColor = .clear
        var colorBottom: UIColor = .clear
        
        switch model.weathers?.first?.main {
        case "Clouds":
            colorTop = .lightGrey
            colorBottom = .black
            self.descriptionLabel.textColor = .white

        case "Clear":
            colorTop = .systemBackground
            colorBottom = .systemBackground
        case "Snow":
            colorTop = .white
            colorBottom = .white
            self.descriptionLabel.textColor = .black

        case "Rain":
            colorTop = .rainyBlue
            colorBottom = .rainyBlue
            self.descriptionLabel.textColor = .white
        case "Thunderstorm":
            colorTop = .nightLightGrey
            colorBottom = .darkGrey
            self.descriptionLabel.textColor = .white

        case "Mist":
            colorTop = .lightYellow
            colorTop = .yellow
            self.descriptionLabel.textColor = .black

        case "Smoke":
            colorTop = .lightGrey
            colorTop = .black
            self.descriptionLabel.textColor = .white

        case "Haze":
            colorTop = .lightYellow
            colorTop = .yellow
            self.descriptionLabel.textColor = .black

        case "Dust":
            colorTop = .lightYellow
            colorTop = .yellow
            self.descriptionLabel.textColor = .black

        case " Fog":
            colorTop = .lightGray
            colorTop = .lightGray
            self.descriptionLabel.textColor = .black

        case "Sand":
            colorTop = .lightYellow
            colorTop = .yellow
            self.descriptionLabel.textColor = .black

        case "Ash":
            colorTop = .darkGray
            colorTop = .nightDarkGrey
            self.descriptionLabel.textColor = .white

        case "Squall":
            colorTop = .orange
            colorTop = .purple
            self.descriptionLabel.textColor = .white

        case "Tornado":
            colorTop = .green
            colorTop = .systemPink
            self.descriptionLabel.textColor = .white

        default:
            colorTop = .blue
            colorBottom = .rainyBlue
            self.descriptionLabel.textColor = .white

        }
        self.circleView.updateColors(top: colorTop, bottom: colorBottom, size: self.circleView.size ?? self.circleView.defaultSize)

    }
    
}
