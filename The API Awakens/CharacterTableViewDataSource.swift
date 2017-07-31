//
//  CharacterTableViewDataSource.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

struct CharacterRow {
    static let length = 2
    static let associatedVehicles = 4
    static let associatedStarships = 5
}

class CharacterTableViewDataSource: NSObject, EntityTableViewDataSource, UITableViewDataSource {
    var numberOfRows: CGFloat = 4.0
    var heightOfRows: CGFloat = 44.0
    var tableViewHeightConstraint: NSLayoutConstraint?
    var entity: Entity?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Standard rows without interactive ones
        numberOfRows = 4.0
        if let character = self.entity as? Character {
            if !character.vehicleUrls.isEmpty {
                numberOfRows += 1.0
            }
            
            if !character.starshipUrls.isEmpty {
                numberOfRows += 1.0
            }
        }
        
        tableViewHeightConstraint?.constant = heightForTableView()
        return Int(numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entityCell = tableView.dequeueReusableCell(withIdentifier: EntityCell.reuseIdentifier, for: indexPath) as! EntityCell
        entityCell.accessoryType = .none
        entityCell.labelValue.isHidden = false
        entityCell.labelKeyWidth.constant = 100.0
        entityCell.selectionStyle = .none
        
        if let character = self.entity as! Character? {
            switch indexPath.row {
            case 0:
                entityCell.labelKey.text = "Birth Year"
                entityCell.labelValue.text = character.birthYear
            case 1:
                entityCell.labelKey.text = "Height"
                entityCell.labelValue.text = character.height
            case 2:
                entityCell.labelKey.text = "Eye Color"
                entityCell.labelValue.text = character.eyeColor
            case 3:
                entityCell.labelKey.text = "Hair Color"
                entityCell.labelValue.text = character.hairColor
            case 4:
                // Not all characters will have vehicles and starships
                // Handling this in the case they have starships but no vehicles
                if character.vehicleUrls.isEmpty {
                    entityCell.labelKey.text = "Associated Starships"
                } else {
                    entityCell.labelKey.text = "Associated Vehicles"
                }
                entityCell.labelValue.isHidden = true
                entityCell.accessoryType = .disclosureIndicator
                entityCell.labelKeyWidth.constant = 200.0
            case 5:
                entityCell.labelKey.text = "Associated Starships"
                entityCell.labelValue.isHidden = true
                entityCell.accessoryType = .disclosureIndicator
                entityCell.labelKeyWidth.constant = 200.0
            
            default: break
            }
        }
        
        if indexPath.row == CharacterRow.associatedVehicles || indexPath.row == CharacterRow.associatedStarships {
            entityCell.selectionStyle = .gray
        }

        return entityCell
    }
}
