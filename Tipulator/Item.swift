//
//  Item.swift
//  Tipulator
//
//  Created by Liu, Samuel Andreson V on 9/5/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class Item: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func load(_ value: Double) {
        let string = String(format: "%.2f", value)
        self.titleLabel.text = "$\(string)"
    }
}
