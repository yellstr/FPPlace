//
//  StoredVenue+CoreDataProperties.swift
//  FPPlace
//
//  Created by Alim Osipov on 11.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import Foundation
import CoreData


extension StoredVenue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredVenue> {
        return NSFetchRequest<StoredVenue>(entityName: "StoredVenue");
    }

    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var id: String?

}
