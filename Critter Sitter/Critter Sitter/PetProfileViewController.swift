//
//  PetProfileViewController.swift
//  Critter Sitter
//
//  Created by Michael Slaughter on 11/15/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import UIKit

class PetProfileViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    var pet: Pet?
    var titles: [String] = ["Name", "Bio", "Food", "Medicine", "Exercise", "Bathroom", "Veterinarian", "Other", "Emergency Contact"]
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(pet!.owner.boolValue == false) {
            self.addPhoto.hidden = true
            self.sendButton.hidden = true
            self.deleteButton.hidden = true
        } else {
            self.addPhoto.hidden = false
            self.sendButton.hidden = false
            self.deleteButton.hidden = false
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            tap.delegate = self
            self.imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
        // Do any additional setup after loading the view.
        self.nameLabel.text = pet!.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = "Pet Profile"
        self.tableView.reloadData()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let selectedImage = image
        imageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if (segue.identifier == "sittingCreate") {
            if let vc = destinationViewController as? SendPetViewController {
                vc.pet = self.pet
            }
        } else if(segue.identifier == "viewDesc") {
            if let vc = destinationViewController as? PetProfileEditViewController {
                vc.pet = self.pet
                vc.str = self.titles[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.titles[indexPath.row]
        
        print(self.titles[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewDesc", sender: self)
    }
    
    @IBAction func savePhoto(sender: AnyObject) {
        uploadImage()
    }
    
    func uploadImage() {
        let myUrl = NSURL(string: "http://discworld-js1h704o.cloudapp.net/test/fileUpload.php");
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "id"  : "\(self.pet!.id)",
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
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString)")
            
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
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
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
