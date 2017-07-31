//
//  VehicleTableViewDataSource.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

struct VehicleRow {
    static let cost = 1
    static let length = 2
}

class VehicleTableViewDataSource: NSObject, EntityTableViewDataSource, UITableViewDataSource {
    var numberOfRows: CGFloat = 5.0
    var heightOfRows: CGFloat = 44.0
    var entity: Entity?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if entity == nil {
            return 0
        }
        return Int(numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vehicle = self.entity as? Vehicle else { fatalError("not supposed to access this until we have an entity") }
        
        if indexPath.row == VehicleRow.cost && Int(vehicle.cost) != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as! CurrencyCell
            
            cell.labelKey.text = "Cost"
            cell.labelValue.text = vehicle.cost
            
            cell.vehicle = vehicle
            cell.creditsButton.isSelected = true
            cell.creditsButton.addTarget(cell, action: #selector(CurrencyCell.convertToCredits), for: .touchUpInside)
            cell.usdButton.addTarget(cell, action: #selector(CurrencyCell.convertToUSD), for: .touchUpInside)
            
            
            cell.usdButton.titleLabel?.textColor = UIColor.gray
            
            
            return cell
        } else if indexPath.row == VehicleRow.length {
            let cell = tableView.dequeueReusableCell(withIdentifier: LengthCell.reuseIdentifier, for: indexPath) as! LengthCell
            cell.labelKey.text = "Length"
            cell.labelValue.text = "\(vehicle.length)m"
            
            cell.entity = vehicle
            cell.metricButton.isSelected = true
            cell.metricButton.addTarget(cell, action: #selector(LengthCell.convertToMetric), for: .touchUpInside)
            cell.usButton.addTarget(cell, action: #selector(LengthCell.convertToUS), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EntityCell.reuseIdentifier, for: indexPath) as! EntityCell
            
            switch indexPath.row {
            case 0:
                cell.labelKey.text = "Make"
                cell.labelValue.text = vehicle.make
            case 1:
                cell.labelKey.text = "Cost"
                cell.labelValue.text = vehicle.cost
            case 2:
                cell.labelKey.text = "Length"
                cell.labelValue.text = vehicle.length
            case 3:
                cell.labelKey.text = "Class"
                cell.labelValue.text = vehicle.type
            case 4:
                cell.labelKey.text = "Crew"
                cell.labelValue.text = vehicle.crew
            default: break
            }
            
            return cell
        }
    }
}
