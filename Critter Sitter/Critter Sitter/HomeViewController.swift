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
    var user = [NSManagedObject]()
    var titles: NSArray = []
    var petSittingIds: NSMutableArray = []
    var petSittingNames: NSMutableArray = []
    var petsIds: NSMutableArray = []
    var petsNames: NSMutableArray = []
    var sendId = 0;
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        
        self.titles = NSArray(objects: "Pets Sitting", "My Pets")
        tableView.delegate = self;
        tableView.dataSource = self;
        
        var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addPet:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        
        self.petSittingIds = NSMutableArray()
        self.petsIds = NSMutableArray()
        self.petSittingNames = NSMutableArray()
        self.petsNames = NSMutableArray()
        // Do any additional setup after loading the view.
        
        loadPets();
    }
    
    func addPet(sender: UIButton) {
        self.performSegueWithIdentifier("petCreate", sender:self)
    }
    // Load core data user
    func loadUser() {
        // Load saved user entities from core data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"User")
        
        do {
            let fetchedResults =
            try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                self.user = results
            } else {
                print("Could not fetch user")
            }
        } catch _{
            return
        }
    }
    
    func loadPets() {
        let post = Poster()
        
        var postString = "http://discworld-js1h704o.cloudapp.net/test/ownedPetsRetrieval.php"
        var dataString = "owner_id=" + (self.user[0].valueForKey("user_id") as! String)
        
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
            if let vc = destinationViewController as? PetProfileCreationViewController {
                vc.user = user[0]
            }
        } else if (segue.identifier == "petProfile") {
            if let vc = destinationViewController as? PetProfileEditViewController {
                vc.pet_id = self.petsIds[self.sendId] as! String
            }
        } else if (segue.identifier == "petSitting") {
            if let vc = destinationViewController as? PetProfileSecondaryViewController {
                vc.pet_sitting_id = self.petSittingIds[self.sendId] as! String
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.sendId = indexPath.row
        if(indexPath.section == 0) {
            // Segue to the Access Code verification
            self.performSegueWithIdentifier("petSitting", sender:self)
        } else {
            self.performSegueWithIdentifier("petProfile", sender:self)
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
