//
//  PetProfileViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pet: Pet?
    var titles: NSArray!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(pet!.owner.boolValue == false) {
            self.editButton.hidden = true
            self.sendButton.hidden = true
            self.deleteButton.hidden = true
        } else {
            self.editButton.hidden = false
            self.sendButton.hidden = false
            self.deleteButton.hidden = false
        }
        // Do any additional setup after loading the view.
        self.nameLabel.text = pet!.name
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.titles = NSArray(objects: "Name", "Bio", "Food", "Medicine", "Exercise", "Bathroom", "Veterinarian", "Other", "Emergency Contact")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "sittingCreate") {
            if let vc = destinationViewController as? SendPetViewController {
                vc.pet = self.pet
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.titles[indexPath.row] as! String
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
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
