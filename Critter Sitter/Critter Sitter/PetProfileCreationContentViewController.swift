//
//  PetProfileContentViewController.swift
//  Critter Sitter
//
//  Created by MU IT Program on 11/24/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileCreationContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoField: UITextView!
    
    var pageIndex: Int!
    
    var titleText: String!
    
    var placeHolderText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.titleText
        
        if(self.pageIndex == 7){
            self.infoField.hidden = true
        }
        else{
            self.infoField.hidden = false
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
