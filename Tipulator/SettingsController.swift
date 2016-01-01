//
//  SettingsController.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/16/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var minTip: UITextField!
    @IBOutlet weak var maxTip: UITextField!
    @IBOutlet weak var defaultTip: UITextField!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkSettings()
        setFields()
    }
    
    func checkSettings() {
        if defaults.floatForKey("maxTip") == 0.0 {
            defaults.setFloat(30.0, forKey: "maxTip")
        }
        if defaults.floatForKey("defaultTip") == 0.0 {
            defaults.setFloat(0.15, forKey: "defaultTip")
        }
    }
    
    func setFields() {
        minTip.text = "\(defaults.floatForKey("minTip"))"
        maxTip.text = "\(defaults.floatForKey("maxTip"))"
        defaultTip.text = "\(defaults.floatForKey("defaultTip")*100)"
    }

    @IBAction func saveSettings(sender: AnyObject) {
        defaults.setFloat(Float(minTip.text!)!, forKey: "minTip")
        defaults.setFloat(Float(maxTip.text!)!, forKey: "maxTip")
        defaults.setFloat(Float(defaultTip.text!)!/100, forKey: "defaultTip")
        
        let alert = UIAlertController(title: "Settings", message:
            "Preferences Saved", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
