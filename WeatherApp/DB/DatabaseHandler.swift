//
//  DatabaseHandler.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/14/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    func deleteObject(name: String){
        
        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "SelectedCity")
        requestDel.returnsObjectsAsFaults = false
        let predicateDel = NSPredicate(format: "name == %@", name)
        requestDel.predicate = predicateDel
        
        
        do {
            let arrUsrObj = try context.fetch(requestDel)
            for usrObj in arrUsrObj as! [NSManagedObject] { // Fetching Object
                context.delete(usrObj) // Deleting Object
                print(usrObj.value(forKey: "name"))
            }
        } catch {
            print("Failed")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    func save(id: Int, name: String, country: String) {
        
        
        if (checkRecordExists(entity: "SelectedCity", name: name)){
            
            
        }
        else{
            guard let entity =
                NSEntityDescription.entity(forEntityName: "SelectedCity", in: context)
                else {
                    return
            }
            
            let city = NSManagedObject(entity: entity,
                                       insertInto: context)
            
            city.setValue(id, forKeyPath: "id")
            city.setValue(name, forKeyPath: "name")
            city.setValue(country, forKeyPath: "country")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func checkRecordExists(entity: String, name: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", name)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
        
    }
    
}
