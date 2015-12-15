//
//  Activity.swift
//  Critter Sitter
//
//  Created by Brendan Niebruegge on 12/14/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import Foundation


class Activity {
    var activity_id: String = ""
    var title: String = ""
    var description: String = ""
    var status: String = ""
    var completion_date: String = ""
    var hasImage: String = ""
    
    init(activity_id: String, title: String, description: String, completion_date: String, hasImage: String, status: String) {
        self.activity_id = activity_id
        self.title = title
        self.description = description
        self.status = status
        self.completion_date = completion_date
        self.hasImage = hasImage
    }
}
