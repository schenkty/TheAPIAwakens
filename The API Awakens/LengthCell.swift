//
//  LengthCell.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

class LengthCell: UITableViewCell {
    
    static let reuseIdentifier = "lengthCell"
    
    weak var entity: Entity?
    
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var usButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    func convertToUS() {
        guard let entity = entity else { fatalError("entity missing") }
        if !usButton.isSelected {
            usButton.isSelected = true
            metricButton.isSelected = false
            
            if let meters = Float(entity.length) {
                let centimeters = meters * 100.0
                let inches = centimeters * 0.39
                let feet = Int(inches) / 12
                let remainingInches = feet % 12
                
                labelValue.text = "\(feet)ft. \(remainingInches)in."
            } else {
                labelValue.text = "Unknown"
            }
            
        }
    }
    
    func convertToMetric() {
        guard let entity = entity else { fatalError("entity missing") }
        if !metricButton.isSelected {
            usButton.isSelected = false
            metricButton.isSelected = true
            
            labelValue.text = "\(entity.length)m"
        }
    }
}
