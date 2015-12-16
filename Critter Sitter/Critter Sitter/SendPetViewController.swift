//
//  SendPetViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class SendPetViewController: UIViewController, UITextFieldDelegate {
    var pet: Pet?
    @IBOutlet weak var emailinput: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker.backgroundColor = UIColor.whiteColor()
        
        endDatePicker.backgroundColor = UIColor.whiteColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create send instance
    @IBAction func send(sender: AnyObject) {
        var postString = "http://discworld-js1h704o.cloudapp.net/test/sittingCreate.php"
        var dataString = "pet_id=" + self.pet!.id + "&email=" + self.emailinput.text! + "&start_date=" + self.startDatePicker.date.description + "&end_date=" + self.endDatePicker.date.description
        
        let post = Poster()
        
        print(self.endDatePicker.date.description)
        print(self.startDatePicker.date.description)
        post.doPost(postString, dataString: dataString) {
            (response, errorStr) -> Void in
            if let errorString = errorStr {
                // Check the POST was successful
                print(errorString)
            } else {
                if let status = response["status"] as? String {
                    if (status == "ok") {
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                } else {
                    // Unknown error occurred
                }
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}
