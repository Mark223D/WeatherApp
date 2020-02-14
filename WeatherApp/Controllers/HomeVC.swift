//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation
import CoreData

class HomeVC: UIViewController {

    @IBOutlet weak var locationsButton: UIBarButtonItem!
    @IBOutlet weak var forecastView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var city: CityResponse?
    private var forecasts: [Forecast]?
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    private let locationManager: CLLocationManager = CLLocationManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    lazy var viewPager: WormTabStrip = {
        
        let view = WormTabStrip(frame: CGRect(x: self.forecastView.frame.origin.x, y: self.forecastView.frame.origin.y, width: self.forecastView.frame.width, height: self.forecastView.frame.height))
        view.delegate = self
        view.eyStyle.wormStyel = .LINE
        view.eyStyle.isWormEnable = false
        view.eyStyle.WormColor = .clear
        view.eyStyle.spacingBetweenTabs = self.forecastView.frame.width/12
        view.eyStyle.topScrollViewBackgroundColor = .clear
        view.eyStyle.dividerBackgroundColor = .clear
        view.eyStyle.tabItemSelectedColor = .label
        view.eyStyle.tabItemDefaultColor = .label
        view.eyStyle.tabItemSelectedFont = UIFont.boldSystemFont(ofSize: 22.0)
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
        if self.forecasts?.count == 0  {
                         self.loader.startAnimating()
                     }
                     else{
                         self.loader.stopAnimating()

                     }
        return index
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.forecasts = []
        
        self.setupLocationAuth()
       
        let resulting: Observable<ForecastResponse> = self.apiCalling.getForecast(apiRequest: APIRequest())
       
        resulting
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (model: ForecastResponse) in
                self.forecasts = model.forecasts
                self.city = model.city
                self.title = model.city?.name ?? ""
                self.view.addSubview(self.viewPager)
                
            })
            .disposed(by: disposeBag)
        if self.forecasts?.count == 0  {
                  self.loader.startAnimating()
              }
              else{
                  self.loader.stopAnimating()

              }
      
    }
    
    
    
    func setupLocationAuth(){
        locationManager.requestAlwaysAuthorization()

        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let forecasts  = self.forecasts else { return }
        
        if forecasts.count > 0 {
                   self.viewPager.selectTabAt(index: getIndexForTime())
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.forecastView.backgroundColor = .clear
        self.loader.hidesWhenStopped = true
    }


    
    func deleteAllData(entity: String)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }





}

extension HomeVC: WormTabStripDelegate{
    func WTSNumberOfTabs() -> Int {
        return self.forecasts?.count ?? 0
    }
    
    func WTSViewOfTab(index: Int) -> UIView {
        let view = ForecastView(frame: CGRect(x: self.forecastView.frame.origin.x - self.forecastView.frame.width/18,
                                              y: self.forecastView.frame.origin.y,
                                              width: self.forecastView.frame.width,
                                              height: self.forecastView.frame.height))
        
        
        if let model = self.forecasts?[index] {
            view.setModel(model)
            self.loader.stopAnimating()
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
        dateFormatterPrint.dateFormat = "EEEE dd - h:mm a"
        
        
        if let date = dateFormatterGet.date(from: str) {
            dateFormatterPrint.dateFormat = "h:mm a"
            var day = ""
            
            if Calendar.current.isDateInToday(date){
                day = "Today "
                day.append( dateFormatterPrint.string(from: date))
                return day
            }
            else if Calendar.current.isDateInTomorrow(date){
                day = "Tomorrow "
                day.append( dateFormatterPrint.string(from: date))
                
                return day
            }
            else if Calendar.current.isDateInYesterday(date){
                day = "Yesterday "
                day.append( dateFormatterPrint.string(from: date))
                
                return day
            }
            else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE dd'\(date.getDayDecorater())', h:mma"
                
                return dateFormatter.string(from: date)
            }
            
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
}

extension HomeVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
