//
//  AccessCodeViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/12/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit
import CoreData

class AccessCodeViewController: UIViewController {

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var user: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Red border for missing inputs
        let missingColor : UIColor = UIColor(red: 1, green: 0, blue:0, alpha: 1.0)
        self.errorLabel.textColor = missingColor
        self.input.layer.borderColor = missingColor.CGColor
        self.input.layer.borderWidth = 0
        self.errorLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func confirmAccount(sender: AnyObject) {
        // Reset border width
        self.input.layer.borderWidth = 0
        
        // Check every input is provided, if not set border for input to red
        if(self.input.text?.isEmpty == true) {
            self.errorLabel.text = "Missing input!"
            self.input.layer.borderWidth = 2
            return
        }
        
        // Create POST object
        let poster = Poster()
        var dataString = ""
        var postString = ""
        
        if let user = user {
            // Construct data string for the post
            dataString += "email=" + self.input.text! + "&code=" + self.input.text!
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
                            // Segue to the Access Code verification
                            self.performSegueWithIdentifier("AccessView", sender:self);
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
