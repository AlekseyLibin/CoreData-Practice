//
//  Auto+CoreDataProperties.swift
//  Vehicles
//
//  Created by Aleksey Libin on 16.02.2023.
//
//

import Foundation
import CoreData


extension Auto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Auto> {
        return NSFetchRequest<Auto>(entityName: "Auto")
    }

    @NSManaged public var name: String?
    @NSManaged public var model: NSSet?

}

// MARK: Generated accessors for model
extension Auto {

    @objc(addModelObject:)
    @NSManaged public func addToModel(_ value: Model)

    @objc(removeModelObject:)
    @NSManaged public func removeFromModel(_ value: Model)

    @objc(addModel:)
    @NSManaged public func addToModel(_ values: NSSet)

    @objc(removeModel:)
    @NSManaged public func removeFromModel(_ values: NSSet)

}

extension Auto : Identifiable {

}
