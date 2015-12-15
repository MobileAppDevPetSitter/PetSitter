//
//  Pet.swift
//  Critter Sitter
//
//  Created by Brendan Niebruegge on 12/12/15.
//  Copyright © 2015 Pet Sitter App. All rights reserved.
//

import Foundation

class Pet {
    var name: String = ""
    var id: String = ""
    var bathroom_instructions = ""
    var exercise: String = ""
    var bio: String = ""
    var medicine: String = ""
    var food: String = ""
    var other: String = ""
    var veterinarian: String = ""
    var owner: BooleanType = false;
    
    init(name: String, id: String, bathroom_instructions: String, exercise: String, bio: String, medicine: String, food: String, veterinarian: String, other: String, owner: BooleanType) {
        self.name = name
        self.id = id
        self.bathroom_instructions = bathroom_instructions
        self.exercise = exercise
        self.bio = bio
        self.food = food
        self.medicine = medicine
        self.other = other
        self.owner = owner
        self.veterinarian = veterinarian
    }
}