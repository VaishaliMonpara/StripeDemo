//
//  cardCell.swift
//  StripeDemo
//
//  Created by harikrishna patel on 19/03/19.
//  Copyright © 2019 Softqube. All rights reserved.
//

import UIKit

class cardCell: UITableViewCell {

    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
