//
//  AddLocationVC.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
import CoreData

class AddLocationVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private let db: DatabaseHandler =  DatabaseHandler()

    private var disposeBag = DisposeBag()
    
    var selectedCities:[Int] = []

    private let allCities: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    private let cities: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    
    private let shownCities: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    private let searchResults: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loader.hidesWhenStopped = true
        self.loader.startAnimating()
        self.setupTableView()
        self.bindTableView()
        self.setupSearchBar()
    }
    
    
    func setupTableView(){
        self.tableView.register(UINib(nibName: "AddLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "addLocationCell")
    }
    
    
    func setupSearchBar(){
        searchBar.rx.text.asObservable().subscribe(onNext: { text in
            if text != nil && text != "" {
                let res = self.allCities.value.filter({ (city) -> Bool in
                    (city.name?.hasPrefix(text ?? "") ?? true)
                })
                self.shownCities.accept(res)
            }
            else if text == "" {
                self.shownCities.accept(self.allCities.value)
                
            }
        }).disposed(by: disposeBag)
    }
    func handleRowSelection(){
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.tableView.cellForRow(at: indexPath) as? AddLocationTableViewCell
                
                let alertHandler = AlertHandler()
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil)
                
                let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) { (action) in
                    if let id = cell?.model?.id,
                        let name = cell?.model?.name,
                        let country = cell?.model?.country
                    {
                        self?.db.save(id: id, name: name, country: country)
//                        self?.navigationController?.popViewController(animated: true)
                    }
                    
                    
                }
                alertHandler.showAlert(on: self ?? AddLocationVC(), with: "You chose \(cell?.titleLabel.text ?? ""). Confirm to add it to your list", and: [cancelAction, confirmAction])
            }).disposed(by: disposeBag)
        
    }
    
    func bindTableView(){
        shownCities.bind(to: tableView.rx.items(cellIdentifier: "addLocationCell")) { row, model, cell in
                   guard let cName = model.name, let cCountry = model.country
                       else {
                           return
                   }
                   let myCell = cell as! AddLocationTableViewCell
                   myCell.titleLabel?.text = cName
                   myCell.subtitleLabel?.text = cCountry
                   myCell.model = model
            self.loader.stopAnimating()

               }.disposed(by: disposeBag)
        
        self.handleRowSelection()
               
    }
    
    func getCities() {
        
        DispatchQueue.background{
            
            let url = Bundle.main.url(forResource: "city.list", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            
            do {
                let city: [City] = try JSONDecoder().decode([City].self, from: data )
                
                let temp = city.filter { (city) -> Bool in
                    guard let c =  city.id else {
                        print("Failed")
                        return false
                    }
                    return !self.selectedCities.contains(c)
                }
                    self.allCities.accept(temp)
                    self.shownCities.accept(temp)
                } catch let error {
                    print(error)
                }
                
            }
        }
        
      
}
