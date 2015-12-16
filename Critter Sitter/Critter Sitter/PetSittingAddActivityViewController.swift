//
//  PetSittingAddActivityViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetSittingAddActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var petSitting: PetSitting?
    var activities = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prevent owners from adding
        if(petSitting!.pet.owner.boolValue == true) {
            var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addActivity:")
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        } 
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func addActivity(sender: UIButton) {
        self.performSegueWithIdentifier("add", sender:self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.activities[indexPath.row] as! String
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
