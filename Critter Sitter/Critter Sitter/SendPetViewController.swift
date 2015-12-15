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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func send(sender: AnyObject) {
        var postString = "http://discworld-js1h704o.cloudapp.net/test/sittingCreate.php"
        var dataString = "pet_id=" + self.pet!.id + "&email=" + self.emailinput.text! + "&start_date=2010-10-02&end_date=2010-10-07"
        
        let post = Poster()
        
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

}
