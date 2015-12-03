//
//  RegisterViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/12/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var pVerificationInput: UITextField!
    var user = [NSManagedObject]()
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Red border for missing inputs
        let missingColor : UIColor = UIColor(red: 1, green: 0, blue:0, alpha: 1.0)
        self.errorLabel.textColor = missingColor
        self.emailInput.layer.borderColor = missingColor.CGColor
        self.passwordInput.layer.borderColor = missingColor.CGColor
        self.pVerificationInput.layer.borderColor = missingColor.CGColor
        self.errorLabel.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        loadUser()
        
        if(user.count == 1) {
            // User is logged in, check for status of account
            var status : String = user[0].valueForKey("status") as! String
            print(status)
            if(status == "PENDING") {
                self.performSegueWithIdentifier("AccessView", sender:self)
            } else {
                // Segue to home page
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        // Load saved user entities from core data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var postString = "http://discworld-js1h704o.cloudapp.net/test/crittermail.php"
        var dataString = ""
        
        // Reset borders to zero, to assume all are inputted
        self.emailInput.layer.borderWidth = 0
        self.passwordInput.layer.borderWidth = 0
        self.pVerificationInput.layer.borderWidth = 0
        self.errorLabel.text = ""
        
        // Check every input is provided, if not set border for input to red
        if(self.emailInput.text?.isEmpty == true) {
            self.emailInput.layer.borderWidth = 2
            return
        } else if(self.passwordInput.text?.isEmpty == true) {
            self.passwordInput.layer.borderWidth = 2
            return
        } else if(self.pVerificationInput.text?.isEmpty == true) {
            self.pVerificationInput.layer.borderWidth = 2
            return
        }
        
        // Create POST object
        let poster = Poster()
        
        // Construct data string for the post
        dataString += "email=" + self.emailInput.text! + "&password=" + self.passwordInput.text!
        print(dataString)
        
        // Perform POST
        poster.doPost(postString, dataString: dataString) {
            (response, errorStr) -> Void in
            if let errorString = errorStr {
                // Check the POST was successful
                self.errorLabel.text = errorString
                print(self.errorLabel.text)
            } else {
                if let status = response["status"] as? String {
                    if (status == "ok") {
                        // Create Core Data entity
                        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
                        let newUser = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                        
                        newUser.setValue(self.emailInput.text!, forKey: "email")
                        newUser.setValue("PENDING", forKey: "status")
                        
                        // Complete save and handle potential error
                        do {
                            try managedContext.save()
                        } catch let error as NSError {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                        
                        // Segue to the Access Code verification
                        self.performSegueWithIdentifier("AccessView", sender:self)
                    } else {
                        // Check for error message
                        if let errorMessage = response["message"] as? String {
                            self.errorLabel.text = errorMessage
                            print(errorMessage)
                        } else {
                            // Unknown error occurred
                            self.errorLabel.text = "Unknown Error!"
                        }
                    }
                } else {
                    // Unknown error occurred
                    self.errorLabel.text = "Unknown Error!"
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        loadUser()
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "AccessView") {
            if let accessViewController = destinationViewController as? AccessCodeViewController {
                    accessViewController.user = user[0]
            }
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

