//
//  PetSittingViewActivityViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetSittingViewActivityViewController: UIViewController {
    var sitting: PetSitting?
    var activity: Activity?
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var activityDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "View Activity"
        
        // Do any additional setup after loading the view.
        
        if(self.sitting!.pet.owner.boolValue == true) {
            self.activityTitle.userInteractionEnabled = false
            self.activityDescription.editable = false
            self.completionDate.hidden = true
        }
        
        if(activity != nil) {
            self.activityTitle.userInteractionEnabled = false
            self.activityTitle.text = activity!.title
            self.activityDescription.text = activity!.description
            self.completionDate.text = "Date:" + activity!.completion_date
            self.activityDescription.editable = false
        } else if(self.sitting!.pet.owner.boolValue != true) {
            var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "add:")
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
            self.completionDate.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func add(sender: UIButton) {
        var post = Poster()
        var postString = "http://discworld-js1h704o.cloudapp.net/test/activityCreate.php"
        var dataString = "pet_sitting_id=" + sitting!.sitting_id + "&title=" + self.activityTitle!.text! + "&description=" + self.activityDescription.text! + "&status=completed"
        
        // Perform POST
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
