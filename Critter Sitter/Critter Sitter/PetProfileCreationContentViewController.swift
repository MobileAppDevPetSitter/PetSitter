//
//  PetProfileContentViewController.swift
//  Critter Sitter
//
//  Created by MU IT Program on 11/24/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileCreationContentViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoField: UITextView!
    
    var pageIndex: Int!
    
    var titleText: String!
    
    var placeHolderText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoField.delegate = self
        
        if let text = self.titleText {
            self.titleLabel.text = text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
