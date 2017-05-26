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
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var taxField: UITextField!
    @IBOutlet weak var tipField: UITextField!
    @IBOutlet weak var itemField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemCollection.dataSource = self
        itemCollection.delegate = self
        
        items = [Double]()
        activeField = itemField
        dropShadow(activeField)
        setTotal(0.00)
        setDetails(0, tip: 0, subtotal: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addButton.layer.cornerRadius = addButton.frame.width * 0.5
    }
    
    func setDetails(_ tax: Double, tip: Double, subtotal: Double) {
        let subtotalString = String(format: "%.2f", subtotal)
        let taxString = String(format: "%.2f", subtotal*tax)
        let tipString = String(format: "%.2f", subtotal*tip)

        detailsLabel.text = "$\(subtotalString)+$\(taxString)+$\(tipString)"
    }
    
    func setTotal(_ value: Double) {
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
    
    @IBAction func numberTapped(_ sender: UIButton) {
        let text = activeField.text
        activeField.text = text! + sender.titleLabel!.text!
        if activeField == taxField || activeField == tipField {
            calculateTotal()
        }
    }
    
    @IBAction func clearTapped(_ sender: AnyObject) {
        activeField.text = ""
        calculateTotal()
    }
    
    @IBAction func decimalTapped(_ sender: AnyObject) {
        activeField.text = activeField.text! + "."
    }
    
    @IBAction func addItem(_ sender: AnyObject) {
        if let input = itemField.text {
            if let value = Double(input) {
                items.append(value)
                itemCollection.reloadData()
                itemField.text = ""
                calculateTotal()
            }
        }
    }
}

extension Home: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string = NSString(format: "%.2f", items[indexPath.row])
        let size = string.size(attributes: nil)
        return CGSize(width: size.width*2.5, height: 25.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        calculateTotal()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! Item
        
        cell.load(items[indexPath.row])
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

extension Home: UITextFieldDelegate {
    
    func removeShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func dropShadow(_ view: UIView) {
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if activeField != nil {
            removeShadow(activeField)
        }
        activeField = textField
        dropShadow(activeField)
        return false
    }
}
