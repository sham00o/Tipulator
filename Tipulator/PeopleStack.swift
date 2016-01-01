//
//  PeopleStack.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/29/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class PeopleStack: UIStackView {
    
    var selected : UITapGestureRecognizer!
    var touch : UITapGestureRecognizer!
    var people : [PersonView]!

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
        people = [PersonView]()
        contentMode = .ScaleAspectFit
        userInteractionEnabled = true
        addPerson()
    }
    
    func addPerson() {
        let person = PersonView()
        person.touch = UITapGestureRecognizer(target: self, action: "highlight:")
        self.addGestureRecognizer(person.touch)
        people.append(person)
    }
    
    func highlight(sender: UITapGestureRecognizer) {
        selected = sender
        print(sender.view)
    }

}
