//
//  Poster.swift
//  Critter Sitter
//
//  Created by Brendan Niebruegge on 11/30/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import Foundation

class Poster {
    
    func doPost(toURLString: String, dataString: String, completionHandler: (NSDictionary, String?) -> Void) {
        let body = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        if let url = NSURL(string: toURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = body;
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(NSDictionary(), error!.localizedDescription)
                    })
                } else {
                    self.parse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(NSDictionary(), "Invalid URL")
            })
        }
    }
    
    private func parse(jsonData: NSData, completionHandler: (NSDictionary, String?) -> Void) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(jsonResult!, nil)
            })
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(NSDictionary(), "Error parsing returned JSON")
            })
        }
    }
    
}