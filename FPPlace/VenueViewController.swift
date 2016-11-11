//
//  VenueViewController.swift
//  FPPlace
//
//  Created by Alim Osipov on 11.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import UIKit
import FoursquareAPIClient

class VenueViewController: UIViewController {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var venue: Venue?
    var client: FoursquareAPIClient?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .black
        
        if venue != nil {
            nameLabel.text = venue?.name
            addressLabel.text = venue?.address
        }

        let parameter: [String: String] = [
            "limit": "1",
            ];
        
        client?.request(path: "venues/\(venue!.id!)/photos", parameter: parameter, completion: { [weak self] (data, error) in
            guard self != nil, let theData = data else {
                print("\(error)")
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: theData) as? NSDictionary {
                    if let photoData = (((jsonObject["response"] as? NSDictionary)?["photos"] as? NSDictionary)?["items"] as? NSArray)?.firstObject as? NSDictionary {
                        self?.showImage(photoData)
                    }
                }
            } catch {
            
            }
        })
    }

    func showImage(_ imageDict: NSDictionary) {
        guard let prefix = imageDict["prefix"] as? String else {return}
        guard let suffix = imageDict["suffix"] as? String else {return}
        
        let imURL = URL(string: prefix + "300x300" + suffix)
        weak var weakSelf = self
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imURL!) {
                let picture = UIImage(data: data)
                DispatchQueue.main.async {
                    weakSelf?.photoImageView.image = picture
                }
            }
        }
    }
}
