//
//  PageViewController.swift
//  Tipulator
//
//  Created by Samuel Liu on 12/16/15.
//  Copyright © 2015 iSam. All rights reserved.
//

import UIKit

@objc protocol PageDelegate {
    optional func calculatePercent(val: Float)
    optional func changeControl(ind: Int)
    optional func setValue(val: Float)
    optional func setNumPeople(num: Int)
    optional func displaySelected(people: [PersonView])
    optional func updateCharges(charges: NSArray)
    optional func selectEveryone()
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, TipDelegate, HomeDelegate, ChargeDelegate {
    
    var segueDelegate : PageDelegate?
    var secondDelegate : PageDelegate?
    var chargeDelegate : PageDelegate?
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        

        let page1: ChargeController! = storyboard?.instantiateViewControllerWithIdentifier("page1") as! ChargeController
        let page2: TipController! = storyboard?.instantiateViewControllerWithIdentifier("page2") as! TipController
        let page3: SettingsController! = storyboard?.instantiateViewControllerWithIdentifier("page3") as! SettingsController
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        secondDelegate = page2
        chargeDelegate = page1
        page1.delegate = self
        page2.delegate = self
    }
    
    func passPercentage(val: Float) {
        segueDelegate?.calculatePercent!(val)
    }
    
    func passIndex(ind: Int) {
        segueDelegate?.changeControl!(ind)
    }
    
    func setSlider(val: Float) {
        secondDelegate?.setValue!(val)
    }
    
    func numPeopleChanged(num: Int) {
        segueDelegate?.setNumPeople!(num)
        chargeDelegate?.setNumPeople!(num)
    }
    
    func displaySelected(people: [PersonView]) {
        segueDelegate?.displaySelected!(people)
    }
    
    func updateCharges(charges: [Charge]) {
        segueDelegate?.updateCharges!(charges)
    }
    
    func selectEveryone() {
        secondDelegate?.selectEveryone!()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == 0 {
            return nil
        }
        return pages[currentIndex-1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        return pages[currentIndex+1]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }

}
