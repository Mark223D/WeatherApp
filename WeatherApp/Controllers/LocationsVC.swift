//
//  LocationsVC.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa
import RxRelay

class LocationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cities: [NSManagedObject] = []
    private let apiCalling = APICalling()
    private var cityWeathers: [CityWeather]?
    private let rxCities: BehaviorRelay<[CityWeather]> = BehaviorRelay(value: [])
    private var disposeBag = DisposeBag()
    
    private let db: DatabaseHandler =  DatabaseHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.hidesWhenStopped = true
        
        
        self.setupTableView()
        self.bindTableView()
        
    }
    
    func setupTableView(){
        self.tableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "locationCell")
        
        self.tableView.delegate = nil
        self.tableView.dataSource  = nil
    }
    
    
    
    func bindTableView(){
        rxCities.bind(to: tableView.rx.items(cellIdentifier: "locationCell")) { row, model, cell in
            let myCell = cell as! LocationCell
            myCell.model = model
            
            if let city = model.city,
                let tempMax = model.info?.tempMax,
                let tempMin = model.info?.tempMin,
                let desc = model.weathers?[0].description,
                let wind = model.wind?.speed
            {
                myCell.titleLabel.text = city
                myCell.tempLabel.text = "\(tempMin)°C - \(tempMax)°C"
                myCell.windLabel.text = "\(wind)km/h"
                myCell.descLabel.text = desc.capitalized
                
            }
            
        }.disposed(by: disposeBag)
        
        self.handleRowDeletion()
        
    }
    func handleRowDeletion (){
        tableView.rx.itemDeleted.subscribe(onNext: { (index) in
            let cell = self.tableView.cellForRow(at: index) as! LocationCell
            
            self.db.deleteObject(name: cell.model?.city ?? "")
            self.cityWeathers  = self.cityWeathers?.filter({ (cityWeather) -> Bool in
                return !(cityWeather.city == cell.titleLabel.text ?? "")
            })
            self.rxCities.accept(self.cityWeathers!)
            
        })
            .disposed(by: disposeBag)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getCities()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddLocationVC {
            
            
            let newVC = segue.destination as? AddLocationVC
            newVC?.getCities()
            
            self.loader.startAnimating()
  
            newVC?.selectedCities = []
            for city in cities{
                if let id: Int = city.value(forKey: "id") as? Int {
                    newVC?.selectedCities.append(id)
                    
                }
            }
            
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        self.loader.startAnimating()
        if self.cities.count < 7 {
            self.performSegue(withIdentifier: "toAdd", sender: self)
        }
        else{
            let alertH = AlertHandler()
            let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alertH.showAlert(on: self, with: "Too many cities choosen (Maximmum 7 Cities). Consider deleting some cities", and: [alertAction])
            
        }
    }
    
    func getCities(){
        DispatchQueue.background{
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "SelectedCity")
            do {
                guard let objects = try? self.context.fetch(fetchRequest) else {
                    return
                }
                self.cities = objects
                if self.cities.count == 0  {
                    self.loader.stopAnimating()
                    self.tableView.isHidden = true
                }
                else{
                    self.loader.startAnimating()
                    self.tableView.isHidden = false

                    
                }
                var ids: [Int] = []
                for object in objects {
                    guard let id = object.value(forKey: "id") as? Int else {
                        return
                    }
                    ids.append(id)
                }
                self.getCityForecasts(ids)
            }
            
        }
    }
    
    func getCityForecasts(_ cities: [Int]) {
        self.cityWeathers = []
        self.apiCalling.testCallIDs(apiRequest: APIRequest(), cities: cities) 
        
        let resulting: Observable<[CityWeather]> = self.apiCalling.getCityForecast(apiRequest: APIRequest(), cities: cities)
        resulting
            .observeOn(MainScheduler.instance).subscribe(onNext: { (forecasts) in
                self.cityWeathers = forecasts
                self.rxCities.accept(forecasts)
                self.loader.stopAnimating()

            }).disposed(by: disposeBag)
        
        
        
    }
}
