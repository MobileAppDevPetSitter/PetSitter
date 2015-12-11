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
    var petSittingIds: NSMutableArray = []
    var petSittingNames: NSMutableArray = []
    var petsIds: NSMutableArray = []
    var petsNames: NSMutableArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titles = NSArray(objects: "Pets Sitting", "My Pets")
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.petSittingIds = NSMutableArray()
        self.petsIds = NSMutableArray()
        self.petSittingNames = NSMutableArray()
        self.petsNames = NSMutableArray()
        // Do any additional setup after loading the view.
        
        loadPets();
    }
    
    func loadPets() {
        let post = Poster()
        
        var postString = "http://discworld-js1h704o.cloudapp.net/test/ownedPetsRetrieval.php"
        var dataString = "owner_id=" + (self.user!.valueForKey("user_id") as! String)
        
        print(dataString)
        // Perform POST
        post.doPost(postString, dataString: dataString) {
            (response, errorStr) -> Void in
            if let errorString = errorStr {
                // Check the POST was successful
                print(errorString)
            } else {
                if let status = response["status"] as? String {
                    if (status == "ok") {
                        print(response)
                        if let sitting = response["pets"] as! NSArray? {
                            for instance in sitting  {
                                var i: NSDictionary = instance as! NSDictionary
                                self.petsIds.addObject(i["pet_id"]!)
                                self.petsNames.addObject(i["name"]!)
                            }
                        }
                    }
                } else {
                    // Unknown error occurred
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.petsIds.removeAllObjects()
        self.petSittingIds.removeAllObjects()
        self.petsNames.removeAllObjects()
        self.petSittingIds.removeAllObjects()
        
        loadPets()
        self.tableView.reloadData()
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
        if(indexPath.section == 0) {
            
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if(indexPath.section == 0) {
            cell.textLabel?.text = petSittingNames[indexPath.row] as! String
        } else {
            cell.textLabel?.text = petsNames[indexPath.row] as! String
        }
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return petSittingIds.count
        } else {
            return petsIds.count
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
