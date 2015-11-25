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
    
    @IBOutlet weak var infoField: UITextField!
    
    @IBOutlet weak var bioField: UITextView!
    
    var pageIndex: Int!
    
    var titleText: String!
    
    var placeHolderText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = self.titleText
        
        self.infoField.placeholder = self.placeHolderText
        
        if(self.pageIndex == 1){
            self.infoField.hidden = true
            
            self.bioField.hidden = false
        }
        else if(self.pageIndex == 7){
            self.infoField.hidden = false
            
            self.bioField.hidden = false
        }
        else{
            self.infoField.hidden = false
            
            self.bioField.hidden = true
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
