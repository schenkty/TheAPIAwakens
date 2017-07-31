//
//  SettingsController.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

struct Settings {
    static var conversionRate: Float = 2.0
}

class SettingsController: UIViewController {
    @IBOutlet weak var conversionRateTextField: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        guard let textFieldValue = conversionRateTextField.text else {
            return
        }
        print("Current Conversion Rate: \(textFieldValue)")
        if Float(textFieldValue)! < 1 {
            Settings.conversionRate = 1
            showAlert(title: "Conversion Rate Not Set", message: "Conversion Rate can not go below 1.0. Set to 1.0")
        } else {
            Settings.conversionRate = Float(textFieldValue)!
            print("Current Conversion Rate: \(textFieldValue)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        conversionRateTextField.text = "\(Settings.conversionRate)"
    }
    
    // Function to add alerts for invalid data
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
