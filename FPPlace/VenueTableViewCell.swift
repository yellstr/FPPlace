//
//  VenueTableViewCell.swift
//  FPPlace
//
//  Created by Alim Osipov on 10.11.16.
//  Copyright © 2016 Alim Osipov. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    @IBOutlet var venueImageView: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
}


class UpdateTableViewCell: UITableViewCell {
    var buttonBlock: (()-> Void)?
    
    @IBAction func buttonAction(_ sender: Any) {
        buttonBlock?()
    }
}
