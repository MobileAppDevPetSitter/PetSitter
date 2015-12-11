//
//  HomeViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit
import CoreData

struct Pet {
    var id: String
    var name: String
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: NSManagedObject?
    var titles: NSArray = []
    var petSitting: NSMutableArray = []
    var pets: NSMutableArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titles = NSArray(objects: "Pets Sitting", "My Pets")
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.petSitting = NSMutableArray()
        self.pets = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    
    func loadPets() {
        let post = Poster()
        
        var postString = "ttp://discworld-js1h704o.cloudapp.net/test/ownedPetsRetrieval.php"
        var dataString = "owner_id=" + (self.user!.valueForKey("user_id") as! String)
        
        // Perform POST
        post.doPost(postString, dataString: dataString) {
            (response, errorStr) -> Void in
            if let errorString = errorStr {
                // Check the POST was successful
                print(errorString)
            } else {
                if let status = response["status"] as? String {
                    if (status == "ok") {
                        if let sitting = response["pets"] as! NSArray? {
                            for instance in sitting  {
                                var i: NSDictionary = instance as! NSDictionary
                                var newPet: Pet = Pet(id: (i["pet_id"] as! String), name: (i["name"] as! String))
                                self.pets.addObject(newPet as! AnyObject)
                            }
                        }
                    }
                } else {
                    // Unknown error occurred
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.pets.removeAllObjects()
        self.petSitting.removeAllObjects()
        
        loadPets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "petCreate") {
            if let homeViewController = destinationViewController as? PetProfileCreationViewController {
                homeViewController.user = user
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if(indexPath.section == 0) {
            cell.textLabel?.text = petSitting[indexPath.row].name
        } else {
            cell.textLabel?.text = pets[indexPath.row].name
        }
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return petSitting.count
        } else {
            return pets.count
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titles[section] as? String
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
