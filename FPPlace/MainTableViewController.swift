//
//  ViewController.swift
//  FPPlace
//
//  Created by Alim Osipov on 10.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import UIKit
import FoursquareAPIClient
import CoreLocation

struct Venue {
    let name: String?
    let address: String?
    let id: String?
    
    func contactInfo () -> String {
        var result = ""
        if address != nil {
            result += "Address: \(address!) "
        }
        if phone != nil {
            result += "Phone: \(phone)"
        }
        return result
    }
}

class MainTableViewController: UITableViewController, CLLocationManagerDelegate {

    let clientID = "T52G4H54GLFUFEUZO34QNFNBS5WRLWUANOESHG5UW10UPEGE"
    let clientSecret = "UNCKMG5MRTHOZ5VEZVRCDDPHAWCPID3CI4I1O0FERTMMECIC"
    var client: FoursquareAPIClient?
    var venues = [Venue]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = FoursquareAPIClient(clientId: clientID, clientSecret: clientSecret)
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = 100
        locationManager.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestLocation()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let result = tableView.dequeueReusableCell(withIdentifier: "topCell")!
            if currentLocation == nil {
                result.textLabel?.text = "Determining your location"
            } else {
                result.textLabel?.text = "Lat: \(currentLocation!.coordinate.latitude), long: \(currentLocation!.coordinate.longitude)"
            }
            return result
        } else {
            let result = tableView.dequeueReusableCell(withIdentifier: "venueCell")! as! VenueTableViewCell
            result.topLabel?.text = venues[indexPath.row - 1].name
            result.bottomLabel?.text = venues[indexPath.row - 1].contactInfo()
            return result
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentLocation = locations.first
            tableView.reloadData()
            searchVenues()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }

    func searchVenues() {
        let parameter: [String: String] = [
            "ll": "\(currentLocation!.coordinate.latitude),\(currentLocation!.coordinate.longitude)",
            "limit": "30",
            ];
        client!.request(path: "venues/search", parameter: parameter) {[weak self] (data, error) in
            guard let `self` = self else {return}
            guard let theData = data else {
                print("Failed with error: \(error)")
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: theData) as? NSDictionary {
                    if let theVenues = (jsonObject["response"] as? NSDictionary)?["venues"] as? Array<NSDictionary> {
                        for item in theVenues {
                            let name = item["name"] as? String
                            let address = (item["location"] as? NSDictionary)?["address"] as? String
                            let id = item["id"] as? String
                            self.venues.append(Venue(name: name , address: address , id: id ))
                        }
                        //print("\(theVenues)")
                    }
                }
                
            } catch {
                print("oops")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

