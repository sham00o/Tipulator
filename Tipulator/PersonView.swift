//
//  PersonView.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/28/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

protocol PersonDelegate {
    func selected(personView: PersonView)
    func deselected(personView: PersonView)
}

class PersonView: UIImageView {
    
    var delegate : PersonDelegate?
    
    var name : String!
    var touch : UITapGestureRecognizer!
    var selected : Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        selected = false
        image = UIImage(named: "man.png")
        contentMode = .ScaleAspectFit
        userInteractionEnabled = true
        touch = UITapGestureRecognizer(target: self, action: "highlight:")
        self.addGestureRecognizer(touch)
    }
    
    func highlight(sender: UITapGestureRecognizer) {
        if !selected {
            image = UIImage(named: "selected.png")
            selected = true
            delegate?.selected(self)
        } else {
            image = UIImage(named: "man.png")
            selected = false
            delegate?.deselected(self)
        }
    }

}
