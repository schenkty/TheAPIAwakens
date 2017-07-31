//
//  Vehicle.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation

class Vehicle: Entity {
    let name: String
    let make: String
    let cost: String
    let length: String
    let type: String
    let crew: String
    
    init(name: String, make: String, cost: String, length: String, type: String, crew: String) {
        self.name = name
        self.make = make
        self.cost = cost
        self.length = length
        self.type = type
        self.crew = crew
    }
}

extension Vehicle {
    struct Key {
        static let name = "name"
        static let make = "manufacturer"
        static let cost = "cost_in_credits"
        static let length = "length"
        static let vehicleType = "vehicle_class"
        static let starshipType = "starship_class"
        static let crew = "crew"
    }
    
    convenience init?(from json: [String: AnyObject]) throws {
        
        guard let name = json[Key.name] as? String,
            let make = json[Key.make] as? String,
            let cost = json[Key.cost] as? String,
            let length = json[Key.length] as? String,
            let crew = json[Key.crew] as? String else {
                throw SWAPIError.invalidData
        }
        
        let vehicleType = json[Key.vehicleType] as? String
        let starshipType = json[Key.starshipType] as? String
        var type = "Unknown"
        
        // It's only ever going to be one of these
        if let vehicleType = vehicleType {
            type = vehicleType.capitalized
        }
        
        if let starshipType = starshipType {
            type = starshipType.capitalized
        }
        
        self.init(name: name, make: make, cost: cost, length: length, type: type, crew: crew)
    }
}
