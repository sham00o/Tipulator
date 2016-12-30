//
//  Item.swift
//  Tipulator
//
//  Created by Liu, Samuel Andreson V on 9/5/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class Item: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(value: Double) {
        let string = String(format: "%.2f", value)
        titleLabel.text = "$\(string)"
    }

}
