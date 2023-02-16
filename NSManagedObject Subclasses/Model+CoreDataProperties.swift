//
//  Model+CoreDataProperties.swift
//  Vehicles
//
//  Created by Aleksey Libin on 16.02.2023.
//
//

import Foundation
import CoreData


extension Model {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: "Model")
    }

    @NSManaged public var name: String?
    @NSManaged public var brand: Auto?

}

extension Model : Identifiable {

}
