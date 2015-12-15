//
//  PetProfileSecondaryViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileSecondaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var petSitting: PetSitting?
    var activities = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.nameLabel.text = petSitting!.pet.name
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        loadActivities()
        self.tableView.reloadData()
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "petProfile") {
            if let vc = destinationViewController as? PetProfileViewController {
                vc.pet = self.petSitting!.pet
            }
        } else if(segue.identifier == "addActivity") {
            if let vc = destinationViewController as? PetSittingViewActivityViewController {
                vc.sitting = self.petSitting
                
                if let id = tableView.indexPathForSelectedRow as! NSIndexPath? {
                    vc.activity = (self.activities[tableView.indexPathForSelectedRow!.row] as! Activity)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath)
        
        cell.textLabel?.text = (activities[indexPath.row] as! Activity).title
        cell.userInteractionEnabled = true
        print((activities[indexPath.row] as! Activity).title)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("HERE")
        self.performSegueWithIdentifier("addActivity", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.activities.count)
        return self.activities.count
    }
    
    func loadActivities() {
        if(self.activities.count != 0) {
            self.activities.removeAllObjects()
        }
        
        let poster = Poster()
        
        var postString = "http://discworld-js1h704o.cloudapp.net/test/activitiesRetrieve.php"
        var dataString = "pet_sitting_id=" + self.petSitting!.sitting_id
        
        // Perform POST
        poster.doPost(postString, dataString: dataString) {
            (response, errorStr) -> Void in
            if let errorString = errorStr {
                // Error
                print(errorStr)
            } else {
                if let status = response["status"] as? String {
                    if (status == "ok") {
                        if let sitting = response["activities"] as! NSArray? {
                            for instance in sitting  {
                                var i: NSDictionary = instance as! NSDictionary
                                let newAct = Activity(activity_id: i["activity_id"] as! String, title: i["title"] as! String, description: i["description"] as! String, completion_date: i["completion_date"] as! String, hasImage: i["hasImage"] as! String, status: "completed");
                                self.activities.addObject(newAct)
                                print(newAct.title)
                            }
                    } else {
                        print("AGH")
                        // Check for error message
                        if let errorMessage = response["message"] as? String {
                            print(errorMessage)
                        } else {
                            // Unknown error occurred
                        }
                    }
                } else {
                    // Unknown error occurred
                   
                }
            }
        self.tableView.reloadData()
        }
        
    }
}
    func loadImage() {
        let postString = "http://discworld-js1h704o.cloudapp.net/test/getImage.php";
        let dataString = "id=" + self.petSitting!.pet.id + "&type=pet"
        
        let body = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        if let url = NSURL(string: postString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = body;
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    
                } else {
                    let image = UIImage(data: data!)
                    self.imageView.image = image
                    self.imageView.image = image

                }
            })
            task.resume()
        } else {

        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
    