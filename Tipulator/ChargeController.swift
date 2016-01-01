//
//  ChargeController.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/16/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class Charge {
    var description: String!
    var price: String!
    var person: String!
    
    init(desc:String, pr:String, p:String) {
        description = desc
        price = pr
        person = p
    }
}

class ChargeCell : UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var onTap: (() -> Void)? = nil
    
    @IBAction func deleteTapped(sender: AnyObject) {
        if let onTap = self.onTap {
            onTap()
        }
    }
    
    func setLabels(charge: Charge) {
        descriptionLabel.text = charge.description
        priceLabel.text = "$\(charge.price)"
        personLabel.text = charge.person
    }
    
}

protocol ChargeDelegate {
    func updateCharges(charges: [Charge])
}

class ChargeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, PageDelegate {
    
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var personField: UITextField!
    @IBOutlet weak var chargeTable: UITableView!
    
    var charges = [Charge]()
    var delegate : ChargeDelegate!
    var numPpl = 1
    var people = ["Person 1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chargeTable.reloadData()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        personField.inputView = pickerView
    }
    
    @IBAction func addItem(sender: AnyObject) {
        let charge = Charge(desc: descriptionField.text!, pr: priceField.text!, p: personField.text!)
        charges.append(charge)
        delegate?.updateCharges(charges)
        chargeTable.reloadData()
        
        descriptionField.text = ""
        priceField.text = ""
        personField.text = ""
    }
    
    func setNumPeople(num: Int) {
        numPpl = num
        people = [String]()
        for (var i=1; i<numPpl+1; i++) {
            people.append("Person \(i)")
        }
    }
    

    // Table delegate methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chargeCell") as! ChargeCell
        
        cell.setLabels(charges[indexPath.row])
        cell.onTap = {
            // remove the deleted item from the model
            self.charges.removeAtIndex(indexPath.row)
            
            // remove the deleted item from the `UITableView`
            self.chargeTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            self.delegate?.updateCharges(self.charges)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charges.count
    }
    
    // Picker delegate methods (for personField input)
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return people.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return people[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        personField.text = people[row]
    }

}
