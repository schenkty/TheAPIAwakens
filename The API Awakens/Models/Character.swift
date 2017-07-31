//
//  Character.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation

class Character: Entity {
    
    let name: String
    let birthYear: String
    let length: String
    let height: String
    let eyeColor: String
    let hairColor: String
    let vehicleUrls: [String]
    let starshipUrls: [String]
    
    init(name: String, birthYear: String, height: String, eyeColor: String, hairColor: String, vehicles: [String], starships: [String]) {
        self.name = name
        self.birthYear = birthYear
        self.height = height
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        self.vehicleUrls = vehicles
        self.starshipUrls = starships
        self.length = height
    }
}

extension Character {
    struct Key {
        static let name = "name"
        static let birthYear = "birth_year"
        static let height = "height"
        static let eyeColor = "eye_color"
        static let hairColor = "hair_color"
        static let vehicles  = "vehicles"
        static let starships = "starships"
    }
    
    convenience init?(from json: [String: AnyObject]) throws {
        
        guard let name = json[Key.name] as? String,
            let birthYear = json[Key.birthYear] as? String,
            let height = json[Key.height] as? String,
            let eyeColor = json[Key.eyeColor] as? String,
            let hairColor = json[Key.hairColor] as? String,
            let vehicles = json[Key.vehicles] as? [String],
            let starships = json[Key.starships] as? [String] else {
                throw SWAPIError.invalidData
        }
        
        self.init(name: name, birthYear: birthYear, height: height, eyeColor: eyeColor.capitalized, hairColor: hairColor.capitalized, vehicles: vehicles, starships: starships)
    }
}
