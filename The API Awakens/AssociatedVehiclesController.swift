//
//  AssociatedVehiclesController.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

enum AssociatedVehicleType {
    case vehicles
    case starships
}

class AssociatedVehiclesController: UITableViewController {
    let client = SWAPIClient()
    var character: Character?
    var vehicleType: AssociatedVehicleType?
    var dataSource = AssociatedVehiclesDataSource()
    
    @IBOutlet weak var vehicleName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        
        if vehicleType == .vehicles {
            pullVehicles()
        } else if vehicleType == .starships {
            pullStarships()
        } else {
            fatalError("Vehicle type not supported")
        }
    }
    
    func pullVehicles() {
        guard let vehicleUrls = character?.vehicleUrls else { fatalError("No URLs found") }
        
        for url in vehicleUrls {
            client.getVehicle(fromURL: url) { vehicle, error in
                DispatchQueue.main.async {
                    self.dataSource.update(with: vehicle!)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func pullStarships() {
        guard let starshipUrls = character?.starshipUrls else { fatalError("No URLs found") }
        
        for url in starshipUrls {
            client.getVehicle(fromURL: url) { vehicle, error in
                DispatchQueue.main.async {
                    self.dataSource.update(with: vehicle!)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // Function to add alerts for invalid data
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
