//
//  NotificationsViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var sitting: PetSitting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accept(sender: AnyObject) {
        // Create POST object
        let poster = Poster()
        
        var postString = "http://discworld-js1h704o.cloudapp.net/test/sittingUpdate.php"
        // Construct data string for the post
        var dataString = "pet_sitting_id=" + self.sitting!.sitting_id + "&status=ACCEPTED"
        
        // Perform POST
        poster.doPost(postString, dataString: dataString) {
            (response, errorStr) -> Void in
            if let errorString = errorStr {
                // Check the POST was successful
                print(errorString)
            } else {
                if let status = response["status"] as? String {
                    if (status == "ok") {
                        // Segue to the Access Code verification
                        self.performSegueWithIdentifier("home", sender:self)
                    }
                } else {
                    // Unknown error occurred
                }
            }
        }
    }
    @IBAction func decline(sender: AnyObject) {
        
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
