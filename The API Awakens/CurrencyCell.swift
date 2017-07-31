//
//  CurrencyCell.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static let reuseIdentifier = "currencyCell"
    
    weak var vehicle: Vehicle?
    
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // We'll always start with galactic credits
        creditsButton.titleLabel?.textColor = .white
    }
    
    func convertToCredits() {
        if !creditsButton.isSelected {
            creditsButton.isSelected = true
            usdButton.isSelected = false
            
            labelValue.text = vehicle?.cost
        }
    }
    
    func convertToUSD() {
        if !usdButton.isSelected {
            guard let vehicle = vehicle else { fatalError("Entity missing") }
            creditsButton.isSelected = false
            usdButton.isSelected = true
            let costString = vehicle.cost
            let cost = Float(costString)!
            
            labelValue.text = "\(Settings.conversionRate * cost)"
        }
    }
}
