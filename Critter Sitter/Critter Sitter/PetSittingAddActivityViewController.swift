//
//  PetSittingAddActivityViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetSittingAddActivityViewController: UIViewController {
    var petSitting: PetSitting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(petSitting!.pet.owner.boolValue == true) {
            var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addActivity:")
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    func addActivity(sender: UIButton) {
        self.performSegueWithIdentifier("add", sender:self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "add") {
            if let vc = destinationViewController as? ActivityAddEventViewController {
                vc.petSitting = self.petSitting
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
