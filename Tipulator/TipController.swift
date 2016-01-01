//
//  TipController.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/16/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

protocol TipDelegate {
    func passPercentage(val: Float)
    func passIndex(ind: Int)
//    func setSlider(slider: UISlider)
    func numPeopleChanged(num: Int)
    func displaySelected(people: [PersonView])
}

class TipController: UIViewController, PageDelegate, PersonDelegate {

    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet var pplStackView: UIStackView!
    @IBOutlet var initialPerson: PersonView!
    
    @IBOutlet var marginY: NSLayoutConstraint!
    
    // get defaults object for data persistence (settings)
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // delegate to pass UI data up to parent HomeController
    var delegate : TipDelegate?
    
    var numPpl = 1
    var ppl = [PersonView]()
    var selectedPpl = [PersonView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tipSlider.hidden = true
        animateControl(0)
        tipSlider.hidden = false
        initialPerson.delegate = self
        initialPerson.name = "Person 1"
        initialPerson.highlight(initialPerson.touch)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureSlider()
    }
    
    func configureSlider() {
        tipSlider.minimumValue = defaults.floatForKey("minTip") != 0.0 ? defaults.floatForKey("minTip") : 0.0
        tipSlider.maximumValue = defaults.floatForKey("maxTip") != 0.0 ? defaults.floatForKey("maxTip") : 30.0
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        delegate?.passPercentage(Float(round(sender.value*10)/1000))
    }

    @IBAction func controlChanged(sender: UISegmentedControl) {
        let val = sender.selectedSegmentIndex
        delegate?.passIndex(val)
        animateControl(val)
    }
    
    func animateControl(ind: Int) {
        if ind == 0 {
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.tipSlider.alpha = 0.0
                self.marginY.constant = -190
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                self.tipSlider.alpha = 1.0
                self.marginY.constant = -145
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func setValue(val: Float) {
        tipSlider.setValue(val, animated: true)
    }
    
    @IBAction func addPerson(sender: AnyObject) {
        numPpl++
        adjustPpl()
        delegate?.numPeopleChanged(numPpl)
    }
    
    @IBAction func subtractPerson(sender: AnyObject) {
        numPpl = numPpl == 1 ? 1 : numPpl-1
        adjustPpl()
        delegate?.numPeopleChanged(numPpl)
    }
    
    func adjustPpl() {
        if numPpl - ppl.count > 0 {
            createPersonView()
        }
        if numPpl - ppl.count <= 0 {
            pplStackView.removeArrangedSubview(ppl.last!)
            if let popped = ppl.popLast() {
                if popped.selected == true {
                    // at each pop, check to see at least one is selected
                    if ppl.count > 0 {
                        var atleastOneSelected = false
                        for person in ppl {
                            if person.selected == true {
                                atleastOneSelected = true
                            }
                        }
                        if !atleastOneSelected {
                            let last = ppl.last
                            if last?.selected == false {
                                last?.highlight(last!.touch)
                            }
                        }
                    }
                    if ppl.count == 0 {
                        if initialPerson.selected == false {
                            initialPerson.highlight(initialPerson.touch)
                        }
                    }
                    deselected(popped)
                }
                popped.removeFromSuperview()
            }
        }
    }
    
    func createPersonView() {
        let imgView = PersonView()
        imgView.name = "Person \(ppl.count+2)"
        imgView.delegate = self
        ppl.append(imgView)
        pplStackView.addArrangedSubview(imgView)
    }
    
    func selectEveryone() {
        for person in ppl {
            if person.selected == false {
                person.highlight(person.touch)
            }
        }
    }
    
    // Person Delegate method
    
    func selected(personView: PersonView) {
        selectedPpl.append(personView)
        delegate?.displaySelected(selectedPpl)
        print("\(selectedPpl.count) selected")
    }
    
    func deselected(personView: PersonView) {
        if selectedPpl.count > 1 {
            selectedPpl.popLast()
            delegate?.displaySelected(selectedPpl)
            print("\(selectedPpl.count) selected")
        } else {
            selectedPpl.popLast()
            personView.highlight(personView.touch)
        }
    }

}
