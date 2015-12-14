//
//  PetProfileEditViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileEditViewController: UIViewController {
    var pet: Pet?
    var str: String?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.pet!.owner.boolValue == false) {
            self.textView.editable = false
            self.button.hidden = true
        }
        
        self.label.text = self.str!
        
        switch(self.str!) {
            case "Name":
                self.textView.text = pet!.name
                break
            case "Bio":
                self.textView.text = pet!.bio
                break
            case "Food":
                break
            case "Medicine":
                self.textView.text = pet!.medicine
                break
            case "Exercise":
                self.textView.text = pet!.exercise
                break
            case "Bathroom":
                self.textView.text = pet!.bathroom_instructions
                break
            case "Veterinarian":
                break
            case "Other":
                self.textView.text = pet!.other
                break
            case "Emergency Contact":
                break
            default:
                break
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: AnyObject) {
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
