//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import RxSwift

class HomeVC: UIViewController {
    
    private var forecasts: [Forecast]?
    
    @IBOutlet weak var forecastView: UIView!
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    
    lazy var viewPager: WormTabStrip = {
        
        let view = WormTabStrip(frame: CGRect(x: self.forecastView.frame.origin.x, y: self.forecastView.frame.origin.y, width: self.forecastView.frame.width, height: self.forecastView.frame.height))
        view.delegate = self
        view.eyStyle.wormStyel = .LINE
        view.eyStyle.isWormEnable = false
        view.eyStyle.WormColor = .clear
        view.eyStyle.spacingBetweenTabs = self.forecastView.frame.width/12
        view.eyStyle.topScrollViewBackgroundColor = .clear
        view.eyStyle.dividerBackgroundColor = .clear
        view.eyStyle.tabItemSelectedColor = .darkGray
        view.eyStyle.tabItemDefaultColor = .darkGray
        view.eyStyle.tabItemSelectedFont = UIFont.boldSystemFont(ofSize: 24.0)
        view.eyStyle.kHeightOfWorm = 4
        
        
        
        view.currentTabIndex = getIndexForTime()
        view.shouldCenterSelectedWorm = true
        view.buildUI()
        
        
        return view
    }()
    
    func getIndexForTime()-> Int {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = formatter.date(from: formatter.string(from: currentDateTime)) else { return 0 }
        
        guard let forecasts = self.forecasts else { return 0 }
        var i = 0
        var index = 0
        for forecast in forecasts {
            guard let fDate = formatter.date(from: forecast.weatherTime ?? "") else { return 0 }
            if fDate == date {
                index = i
            }
            i = i + 1
        }
        return index
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let request =  APIRequest()
        self.forecasts = []
        let resulting: Observable<[Forecast]> = self.apiCalling.getForecast(apiRequest: request)
        resulting
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (forecasts: [Forecast]) in
                self.forecasts = forecasts
                self.view.addSubview(self.viewPager)
                
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forecastView.backgroundColor = .clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.view.setGradientBackground(top: .white, bottom: .lightYellow)
        
        
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
        
        
    }
    
    
}



extension HomeVC: WormTabStripDelegate{
    func WTSNumberOfTabs() -> Int {
        return self.forecasts?.count ?? 0
    }
    
    func WTSViewOfTab(index: Int) -> UIView {
        let view = ForecastView(frame: CGRect(x: self.forecastView.frame.origin.x - self.forecastView.frame.width/18, y: self.forecastView.frame.origin.y, width: self.forecastView.frame.width, height: self.forecastView.frame.height))
        
        if let model = self.forecasts?[index] {
            view.setModel(model)
            
        }
        
        return view
    }
    
    func WTSTitleForTab(index: Int) -> String {
        
        return formatTime(forecasts?[index].weatherTime)
    }
    
    func WTSReachedLeftEdge(panParam: UIPanGestureRecognizer) {
    }
    
    func WTSReachedRightEdge(panParam: UIPanGestureRecognizer) {
    }
    
    func formatTime(_ strTime: String?) -> String {
        guard let str = strTime
            else {
                return ""
        }
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone = .current
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.timeZone = .autoupdatingCurrent
        dateFormatterPrint.dateFormat = "h:mm a"
        
        if let date = dateFormatterGet.date(from: str) {
            
            return dateFormatterPrint.string(from: date)
            
        } else {
            print("There was an error decoding the string")
            return ""
        }
        
        
    }
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
