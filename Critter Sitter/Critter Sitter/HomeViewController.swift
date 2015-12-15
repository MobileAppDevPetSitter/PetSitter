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
    var sendId = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        
        self.titles = NSArray(objects: "Pets Sitting", "My Pets")
        tableView.delegate = self
        tableView.dataSource = self
        
        var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addPet:")
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        var leftAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        self.navigationItem.setLeftBarButtonItems([leftAddBarButtonItem], animated: true)
        
        self.petsSitting = NSMutableArray()
        self.pets = NSMutableArray()
        
        // Do any additional setup after loading the view.
    }
    
    func logout(sender: UIButton) {
        // Load saved user entities from core data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        do {
            try managedContext.deleteObject(self.user[0])
        } catch let error as NSError {
            
            }
        // Complete save and handle potential error
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    
        self.performSegueWithIdentifier("logout", sender:self)
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
        if(self.pets.count != 0 || self.petsSitting.count != 0) {
            self.pets.removeAllObjects()
            self.petsSitting.removeAllObjects()
        }
        let post = Poster()
        
        var postString = "http://discworld-js1h704o.cloudapp.net/test/ownedPetsRetrieval.php"
        var dataString = "owner_id=" + (self.user[0].valueForKey("user_id") as! String)
        
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
                                let newPet = Pet(name: i["name"]! as! String, id: i["pet_id"]! as! String, bathroom_instructions: i["bathroom"]! as! String, exercise: i["exercise"]! as! String, bio: i["bio"]! as! String, medicine: i["medicine"] as! String, food: i["food"] as! String, veterinarian: i["vet"] as! String, other: i["other"] as! String, owner: true)
                                    self.pets.addObject(newPet)
                            }
                        }
                        if let mine_sitting = response["mine_sitting"] as! NSArray? {
                            var temp: Pet?
                            
                            for instance in mine_sitting  {
                                let p: NSDictionary = instance as! NSDictionary
                            
                                var j = 0
                                for(j = 0; j < self.pets.count; j++) {
                                    if((self.pets[j] as! Pet).id == p["pet_id"]! as! String) {
                                        temp = self.pets[j] as? Pet
                                    
                                        let newSitting = PetSitting(pet: temp!, start_date: p["start"]! as! String, end_date: p["end"]! as! String, sitting_id: p["pet_sitting_id"]! as! String, status: p["currentStatus"] as! String)
                                    
                                        self.petsSitting.addObject(newSitting)
                                        break
                                    }
                                }
                            }
                        }
                    
                        postString = "http://discworld-js1h704o.cloudapp.net/test/petsSitting.php"
                        print(dataString)
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
                                                
                                                let newPet = Pet(name: i["name"]! as! String, id: i["pet_id"]! as! String, bathroom_instructions: i["bathroom"]! as! String, exercise: i["exercise"]! as! String, bio: i["bio"]! as! String, medicine: i["medicine"] as! String, food: i["food"] as! String!, veterinarian: i["vet"] as! String, other: i["other"] as! String, owner: false)
                                                
                                                let newSitting = PetSitting(pet: newPet, start_date: i["start_date"]! as! String, end_date: i["end_date"]! as! String, sitting_id: i["pet_sitting_id"]! as! String, status: "pending")
                                                    
                                                self.petsSitting.addObject(newSitting);
                                            }
                                        }
                                    }
                                    self.tableView.reloadData()
                                } else {
                                    // Unknown error occurred
                                }
                            }
                        }
                    }
                } else {
                    // Unknown error occurred
                }
                
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadPets()
        sendId = -1
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
                if(self.sendId == -1) {
                    vc.petSitting = self.petsSitting[tableView.indexPathForSelectedRow!.row] as! PetSitting
                } else {
                    vc.petSitting = self.petsSitting[self.sendId] as! PetSitting
                }
            }
        } else if (segue.identifier == "notify") {
            if let vc = destinationViewController as? NotificationsViewController {
                vc.sitting = self.petsSitting[tableView.indexPathForSelectedRow!.row] as! PetSitting
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0) {
            // Segue to the Access Code verification
            if((self.petsSitting[tableView.indexPathForSelectedRow!.row] as! PetSitting).status == "pending") {
                self.performSegueWithIdentifier("notify", sender: self)
            } else {
                self.performSegueWithIdentifier("petSitting", sender:self)
            }
        } else {
            self.performSegueWithIdentifier("petProfile", sender:self)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if(indexPath.section == 0) {
            cell.textLabel?.text = (petsSitting[indexPath.row] as! PetSitting).pet.name
            
            if((petsSitting[indexPath.row] as! PetSitting).pet.owner.boolValue == true) {
                var i = 0
                for(i = 0; i < self.pets.count; i++) {
                    if((self.petsSitting[indexPath.row] as! PetSitting).pet.id == (pets[i] as! Pet).id) {
                        cell.accessoryType = .DetailDisclosureButton
                        break
                    }
                }
            }
        } else {
            cell.textLabel?.text = (pets[indexPath.row] as! Pet).name
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        sendId = indexPath.row
        self.performSegueWithIdentifier("petSitting", sender: self);
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
