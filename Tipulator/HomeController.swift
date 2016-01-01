//
//  ViewController.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/15/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

protocol HomeDelegate {
    func setSlider(val: Float)
    func selectEveryone()
}

class HomeController: UIViewController, UITextFieldDelegate, PageDelegate {

    @IBOutlet weak var control: UISegmentedControl!
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercent: UILabel!
    @IBOutlet weak var stack: UIStackView!
    
    // constraint to manipulate animation
    @IBOutlet weak var controlConstraint: NSLayoutConstraint!
    
    var delegate : HomeDelegate?
    
    var selectedPeople = [PersonView]()
    var charges = [Charge]()
    var selectedChargeSum : Float = 0.0
    var totalChargeSum : Float = 0.0
    var numSelected : Int!
    var numPeople : Int!
    var controlInd = 0
    var percentValue : Float!
    var subtotalValue : Float!
    var totalValue : Float!
    var formattedPerc : String!
    var formattedTip : String!
    var formattedSub : String!
    var formattedTotal : String!
    var userInput : String!
    var dismissTap : UITapGestureRecognizer!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        percentValue = defaults.floatForKey("defaultTip") != 0.0 ? defaults.floatForKey("defaultTip") : 0.15
    }
    
    func initialize() {
        stack.hidden = true
        subtotalValue = 0.0
        numPeople = 1
        numSelected = 1
        
        dismissTap = UITapGestureRecognizer(target: self, action: "dismiss:")
        view.addGestureRecognizer(dismissTap)
        // open keyboard
        total.becomeFirstResponder()
    }
    
    func calculate() {
        let tipValue = subtotalValue*percentValue
        formattedPerc = NSString(format:"%.2f", percentValue*100) as String
        formattedTip = NSString(format:"%.2f", tipValue) as String
        formattedSub = NSString(format:"%.2f",subtotalValue) as String
        totalValue = subtotalValue + tipValue
        formattedTotal = NSString(format: "%.2f", totalValue) as String
        switch controlInd {
        case 0:
            formattedSub = userInput
            break
        case 1:
            formattedTip = userInput
            break
        default:
            formattedTotal = userInput
        }
        let substring = "$\(formattedSub) + $\(formattedTip) = $\(formattedTotal)"
//        let customString = NSMutableAttributedString(string: substring as String, attributes: nil)
//        customString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSMakeRange(1, substring.length))
        subtotal.text = substring
        tipPercent.text = "\(formattedPerc)%"
        adjustView()
    }
    
    func sliderCalculate() {
        let tipValue = subtotalValue*percentValue
        formattedPerc = NSString(format:"%.2f", percentValue*100) as String
        formattedTip = NSString(format:"%.2f", tipValue) as String
        formattedSub = NSString(format:"%.2f",subtotalValue) as String
        totalValue = subtotalValue + tipValue
        formattedTotal = NSString(format: "%.2f", totalValue) as String
        subtotal.text = "$\(formattedSub) + $\(formattedTip) = $\(formattedTotal)"
        tipPercent.text = "\(formattedPerc)%"
        adjustView()
    }
    
    // Dismiss keyboard and process total
    func dismiss(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func changeControl(ind: Int) {
        total.becomeFirstResponder()
        controlInd = ind
        adjustView()
    }
    
    func adjustView() {
        switch controlInd {
        case 0:
            total.text = formattedSub
            break
        case 1:
            total.text = formattedTip
            break
        default:
            total.text = formattedTotal
        }
    }

    // Textfield methods
    
    @IBAction func amountChanged(sender: UITextField) {
        stack.hidden = false
        userInput = sender.text
        if controlInd == 0 {
            if let val = Float(userInput) {
                subtotalValue = val
            } else {
                subtotalValue = 0.0
                stack.hidden = true
            }
            calculate()
        } else if controlInd == 1 {
            if subtotalValue != 0.0 {
                if let val = Float(userInput) {
                    percentValue = (val/subtotalValue)

                } else {
                    percentValue = 0.0
                }
                let perc = percentValue*100
                delegate?.setSlider(perc)
                calculate()
            } else {
                stack.hidden = true
            }
        } else {
            if subtotalValue != 0.0 {
                if let val = Float(userInput) {
                    let diff = val-subtotalValue
                    percentValue = (diff/subtotalValue)
                } else {
                    percentValue = 0.0
                }
                let perc = percentValue*100
                delegate?.setSlider(perc)
                calculate()
            } else {
                stack.hidden = true
            }
        }
    }
    
    func setNumPeople(num: Int) {
        subtotalValue = Float(numPeople)*subtotalValue/Float(num)
        numPeople = num
        sliderCalculate()
    }
    
    var deductedSubtotal : Float = 0.0
    
    func displaySelected(people: [PersonView]) {
        selectedPeople = people
        selectedChargeSum = 0.0
        for person in people {
            for charge in charges {
                if person.name == charge.person {
                    selectedChargeSum = selectedChargeSum + Float(charge.price)!
                }
            }
        }
        if charges.count == 0 { // if no specific charges
            subtotalValue = Float(people.count)*subtotalValue/Float(numSelected)
        } else { // TODO: implement charge calculations
            subtotalValue = Float(people.count)*subtotalValue/Float(numSelected)

//            print(people.count)
//            subtotalValue = (Float(numSelected)*deductedSubtotal/Float(numPeople)) + selectedChargeSum
        }
        numSelected = people.count
        sliderCalculate()
    }
    
    func updateCharges(charges: NSArray) {
        delegate?.selectEveryone()
        self.charges = charges as! [Charge]
        for charge in self.charges {
            totalChargeSum = totalChargeSum + Float(charge.price)!
        }
        deductedSubtotal = subtotalValue-totalChargeSum
        displaySelected(selectedPeople)
    }
    
    // Slider methods
    
    func calculatePercent(val: Float) {
        percentValue = val
        if subtotalValue != 0.0 {
            sliderCalculate()
        } else {
            calculate()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toContainer" {
            let dest = segue.destinationViewController as! PageViewController
            dest.segueDelegate = self
            delegate = dest
        }
    }

}

