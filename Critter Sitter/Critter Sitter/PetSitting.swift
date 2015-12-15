//
//  PetSitting.swift
//  Critter Sitter
//
//  Created by Brendan Niebruegge on 12/13/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import Foundation

class PetSitting {
    var pet: Pet
    var start_date: String = ""
    var end_date: String = ""
    var sitting_id: String = ""
    var status: String = ""
    
    init(pet: Pet, start_date: String, end_date: String, sitting_id: String, status: String) {
        self.pet = pet
        self.start_date = start_date
        self.end_date = end_date
        self.sitting_id = sitting_id
        self.status = status
    }
}
