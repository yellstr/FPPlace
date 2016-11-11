//
//  VenuesTableViewController.swift
//  FPPlace
//
//  Created by Alim Osipov on 11.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import UIKit

protocol VenuesTableViewControllerDelegate {
    func didSelectRow(_ row: Int)
}

class VenuesTableViewController: UITableViewController {

    let venues = ["Venue 1", "Venue 2", "Venue 3", "Venue 4", "Venue 5"]
    
    var delegate: VenuesTableViewControllerDelegate?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath)

        cell.textLabel?.text = venues[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        delegate?.didSelectRow(indexPath.row)
        return false
    }
}
