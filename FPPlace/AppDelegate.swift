//
//  AppDelegate.swift
//  FPPlace
//
//  Created by Alim Osipov on 10.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var externalVenue: Venue?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //externalVenue = Model.sharedInstance.retrieveVenues().first
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Model.sharedInstance.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Model.sharedInstance.saveContext()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.host == nil
        {
            return true;
        }
        
        let urlString = url.absoluteString
        let queryArray = urlString.components(separatedBy:"/")
        
        if queryArray.count > 4 {
            externalVenue = Venue(name: queryArray[2], address: queryArray[3], id: queryArray[4])
        }
        return true
    }
}

