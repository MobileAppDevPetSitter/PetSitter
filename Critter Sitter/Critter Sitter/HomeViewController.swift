//
//  HomeViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user = [NSManagedObject]()
    var titles: NSArray = []
    var petsSitting: NSMutableArray = []
    var pets: NSMutableArray = []
    var sendId = 0;

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        
        self.titles = NSArray(objects: "Pets Sitting", "My Pets")
        tableView.delegate = self
        tableView.dataSource = self
        
        var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addPet:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        
        self.petsSitting = NSMutableArray()
        self.pets = NSMutableArray()
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
                                let newPet = Pet(name: i["name"]! as! String, id: i["pet_id"]! as! String, bathroom_instructions: i["bathroom"]! as! String, exercise: i["exercise"]! as! String, bio: i["bio"]! as! String, medicine: "Loud" as! String, other: "None" as! String, owner: true)
                                self.pets.addObject(newPet)
                            }
                        }
                    }
                } else {
                    // Unknown error occurred
                }
            }
            self.tableView.reloadData()
        }
            postString = "http://discworld-js1h704o.cloudapp.net/test/petsSitting.php"
        
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
                                    var doesOwn:BooleanType = false;
                                    var i: NSDictionary = instance as! NSDictionary
                                    
                                    var j = 0
                                    for(j = 0; j < self.pets.count; j++) {
                                        if((self.pets[j] as! Pet).id == i["pet_id"]! as! String) {
                                            doesOwn = true
                                            break
                                        }
                                    }
                                    
                                    let newPet = Pet(name: i["name"]! as! String, id: i["pet_id"]! as! String, bathroom_instructions: i["bathroom"]! as! String, exercise: i["exercise"]! as! String, bio: i["bio"]! as! String, medicine: "Loud" as! String, other: "None" as! String, owner: doesOwn.boolValue)
                                    self.petsSitting.addObject(newPet)
                                }
                            }
                        }
                    } else {
                        // Unknown error occurred
                    }
                }
                self.tableView.reloadData()
            }
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.pets.removeAllObjects()
        self.petsSitting.removeAllObjects()
        
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
            if let vc = destinationViewController as? PetProfileViewController {
                vc.pet = self.pets[tableView.indexPathForSelectedRow!.row] as! Pet
            }
        } else if (segue.identifier == "petSitting") {
            if let vc = destinationViewController as? PetProfileSecondaryViewController {
                vc.pet = self.petsSitting[tableView.indexPathForSelectedRow!.row] as! Pet
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
            cell.textLabel?.text = (petsSitting[indexPath.row] as! Pet).name
        } else {
            cell.textLabel?.text = (pets[indexPath.row] as! Pet).name
        }
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return petsSitting.count
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
