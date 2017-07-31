//
//  AssociatedVehiclesDataSource.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

class AssociatedVehiclesDataSource: NSObject, UITableViewDataSource {
    private var data = [Vehicle]()
    
    func update(with vehicle: Vehicle) {
        data.append(vehicle)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleCell", for: indexPath) as! VehicleCell
        cell.vehicleName.text = data[indexPath.row].name
        return cell
    }
}
