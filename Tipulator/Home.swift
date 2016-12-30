//
//  Home.swift
//  Tipulator
//
//  Created by Liu, Samuel Andreson V on 9/5/16.
//  Copyright © 2016 iSam. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    var activeField: UITextField!
    var items: [Double]!

    @IBOutlet weak var totalField: UITextField!
    @IBOutlet weak var itemTable: UITableView!
    @IBOutlet weak var taxField: UITextField!
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = [Double]()
        activeField = itemField
        dropShadow(activeField)
        setTotal(0.00)
        setDetails(0, tip: 0, subtotal: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addButton.layer.cornerRadius = addButton.frame.width * 0.5
        subtractButton.layer.cornerRadius = subtractButton.frame.width * 0.5
    }
    
    func setDetails(tax: Double, tip: Double, subtotal: Double) {
        let subtotalString = String(format: "%.2f", subtotal)
        let taxString = String(format: "%.2f", subtotal*tax)
        let tipString = String(format: "%.2f", subtotal*tip)

        detailsLabel.text = "$\(subtotalString)+$\(taxString)+$\(tipString)"
    }
    
    func setTotal(value: Double) {
        let string = String(format: "%.2f", value)
        totalField.text = "$\(string)"
    }
    
    func calculateTotal() {
        var subtotal = 0.0
        for item in items {
            subtotal += item
        }
        let tax = taxField.text != "" ? Double(taxField.text!)!/100 : 0
        let tip = tipField.text != "" ? Double(tipField.text!)!/100 : 0
        let total =  subtotal * (1+tax+tip)
        setTotal(total)
        setDetails(tax, tip: tip, subtotal: subtotal)
    }
    
    @IBAction func numberTapped(sender: UIButton) {
        let text = activeField.text
        activeField.text = text! + sender.titleLabel!.text!
        if activeField == taxField || activeField == tipField {
            calculateTotal()
        }
    }
    
    @IBAction func clearTapped(sender: AnyObject) {
        activeField.text = ""
        calculateTotal()
    }
    
    @IBAction func decimalTapped(sender: AnyObject) {
        activeField.text = activeField.text! + "."
    }
    
    @IBAction func addItem(sender: AnyObject) {
        if let input = itemField.text {
            if let value = Double(input) {
                items.append(value)
                itemField.text = ""
                calculateTotal()
                itemTable.reloadData()
            }
        }
    }
    
    @IBAction func removeItem(sender: AnyObject) {
        if items.count > 0 {
            items.removeLast()
            itemTable.reloadData()
        }
        calculateTotal()
    }

}

extension Home: UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath) as! Item
        
        cell.setLabel(items[indexPath.row])
        
        return cell
    }
}

extension Home: UITextFieldDelegate {
    
    func removeShadow(view: UIView) {
        view.layer.shadowColor = UIColor.clearColor().CGColor
    }
    
    func dropShadow(view: UIView) {
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if activeField != nil {
            removeShadow(activeField)
        }
        activeField = textField
        dropShadow(activeField)
        return false
    }
}
