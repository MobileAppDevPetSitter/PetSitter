//
//  PetProfileSecondaryViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileSecondaryViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var petSitting: PetSitting?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.nameLabel.text = petSitting!.pet.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "petProfile") {
            if let vc = destinationViewController as? PetProfileViewController {
                vc.pet = self.petSitting!.pet
            }
        } else if(segue.identifier == "viewActivities") {
            if let vc = destinationViewController as? PetSittingAddActivityViewController {
                vc.petSitting = self.petSitting
            }
        }
    }
    
func loadImage() {
    let myUrl = NSURL(string: "http://discworld-js1h704o.cloudapp.net/test/fileUpload.php");
    //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
    
    let request = NSMutableURLRequest(URL:myUrl!);
    request.HTTPMethod = "POST";
    
    let param = [
        "id"  : "\(self.petSitting!.pet.id)",
        "type"    : "pet"
    ]
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    
    let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
    
    if(imageData==nil)  { return; }
    
    request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
    
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        data, response, error in
        
        if error != nil {
            print("error=\(error)")
            return
        }
        
        
        dispatch_async(dispatch_get_main_queue(),{
            self.imageView.image = UIImage(data: data!);
        });
        
        
    }
    
    task.resume()
    
}

func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    var body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
    }
    
    return body
}




func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().UUIDString)"
}



}
