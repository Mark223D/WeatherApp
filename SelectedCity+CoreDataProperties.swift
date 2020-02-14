//
//  SelectedCity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/14/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//
//

import Foundation
import CoreData


extension SelectedCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SelectedCity> {
        return NSFetchRequest<SelectedCity>(entityName: "SelectedCity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var country: String?

}
