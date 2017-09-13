//
//  AirportTableViewCell.swift
//  OKRoger-v1
//
//  Created by Ash Sharma on 4/5/16.
//  Copyright © 2016 Ash Sharma. All rights reserved.
//

import UIKit

class AirportTableViewCell: UITableViewCell {

    var airport: Airport? {
        didSet {
            updateUI()
        }
    }

    
    @IBOutlet weak var codeIATALabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        if let airport = self.airport {
            
            let mutableIATALabel = NSMutableAttributedString(string: airport.codeIATA)
            mutableIATALabel.addAttributes([ NSForegroundColorAttributeName: UIColor.darkText], range: NSMakeRange(0, airport.codeIATA.characters.count))
            codeIATALabel?.attributedText = mutableIATALabel
            
            let mutableNameLabel = NSMutableAttributedString(string: airport.name)
            mutableNameLabel.addAttributes([ NSForegroundColorAttributeName: Constants.appleBlueColor], range: NSMakeRange(0, airport.name.characters.count))
            nameLabel?.attributedText = mutableNameLabel
            
            let mutableDetailLabel = NSMutableAttributedString(string: airport.city+", "+airport.country)
            mutableDetailLabel.addAttributes([ NSForegroundColorAttributeName: UIColor.darkGray], range: NSMakeRange(0,airport.city.characters.count))
            detailLabel.attributedText = mutableDetailLabel
        }
    }

}
