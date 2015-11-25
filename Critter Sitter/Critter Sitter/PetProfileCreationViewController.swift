//
//  PetProfileCreationViewController.swift
//  Critter Sitter
//
//  Created by MU IT Program on 11/24/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileCreationViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var placeHolderText: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "Name", "Bio", "Food", "Medicine", "Exercise", "Bathroom", "Veterinarian", "Add Photo", "Other", "Emergency Contact", "Owners")
        
        self.placeHolderText = NSArray(objects: "Enter Name", "Enter Bio", "Enter Food", "Enter Medicine", "Enter Exercise", "Enter Bathroom", "Enter Veterinarian", "", "Enter Other", "Enter Emergency Contact", "Enter Owners")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PetCreationPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as PetProfileCreationContentViewController
        
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers((viewControllers as! [UIViewController]), direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
        
        self.addChildViewController(self.pageViewController)
        
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func restartAction(sender: AnyObject) {
        
    }
    
    func viewControllerAtIndex(index: Int) -> PetProfileCreationContentViewController {
        if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return PetProfileCreationContentViewController()
        }
        
        let vc: PetProfileCreationContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PetProfileCreationContentViewController") as! PetProfileCreationContentViewController
        
        vc.titleText = self.pageTitles[index] as! String
        
        vc.placeHolderText = self.placeHolderText[index] as! String
        
        vc.pageIndex = index
        
        return vc
    }
    
    //MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! PetProfileCreationContentViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! PetProfileCreationContentViewController
        var index = vc.pageIndex as Int
        
        if(index == NSNotFound){
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
