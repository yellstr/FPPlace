//
//  Model.swift
//  FPPlace
//
//  Created by Alim Osipov on 11.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import Foundation
import CoreData

class Model {
    static let sharedInstance = Model()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FPPlace")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func store(_ venues:[Venue]) {
        var i: Int16 = 0
        for venue in venues {
            let newObject = NSEntityDescription.insertNewObject(forEntityName: "StoredVenue", into: context) as! StoredVenue
            newObject.index = i
            newObject.id = venue.id
            newObject.name = venue.name
            newObject.address = venue.address
            i += 1
        }
        saveContext()
    }

    func retrieveVenues() -> [Venue] {
        var result = [Venue]()
        let request: NSFetchRequest<StoredVenue> = StoredVenue.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        if let storedVenues = try? context.fetch(request) {
            for object in storedVenues {
                let newVenue = Venue(name: object.name, address: object.address, id: object.id)
                result.append(newVenue)
            }
        }
        return result
    }
    
    func clearVenues () {
        let request: NSFetchRequest<StoredVenue> = StoredVenue.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        if let storedVenues = try? context.fetch(request) {
            for object in storedVenues {
                context.delete(object)
            }
            saveContext()
        }
    }
}
