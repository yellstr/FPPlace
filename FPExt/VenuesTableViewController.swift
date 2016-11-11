//
//  VenuesTableViewController.swift
//  FPPlace
//
//  Created by Alim Osipov on 11.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import UIKit

protocol VenuesTableViewControllerDelegate {
    func didSelect(_ venue: Venue)
}

class VenuesTableViewController: UITableViewController {

    var venues = Model.sharedInstance.retrieveVenues()
    
    var delegate: VenuesTableViewControllerDelegate?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath) as! TopVenuesTableViewCell
            if let parentVC = parent as? MessagesViewController {
                cell.extensionContext = parentVC.extensionContext
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath)
        cell.textLabel?.text = venues[indexPath.row - 1].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row > 0 {
            delegate?.didSelect(venues[indexPath.row - 1])
        }
        return false
    }
}


class TopVenuesTableViewCell : UITableViewCell {
    
    var extensionContext: NSExtensionContext?
    
    @IBAction func goToApp(_ sender: UIButton) {
        let myURL = URL(string: "fpplace:/" + "/dummy/")
        extensionContext?.open(myURL!, completionHandler: { (success) in
            
        })
    }
}
