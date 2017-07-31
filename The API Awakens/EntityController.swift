//
//  EntityController.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

class EntityController: UIViewController, UITableViewDelegate {
    var entityType: EntityType?
    let client = SWAPIClient()
    
    var pickerDataSource: EntityPickerDataSource?
    var pickerDelegate: UIPickerViewDelegate?
    var tableViewDataSource: UITableViewDataSource?
    var currentPage = 1
    var selectedVehicleType: AssociatedVehicleType?

    @IBOutlet weak var entityName: UILabel!
    @IBOutlet weak var entityPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var quickBarSmallKey: UILabel!
    @IBOutlet weak var quickBarSmallValue: UILabel!
    @IBOutlet weak var quickBarLargeKey: UILabel!
    @IBOutlet weak var quickBarLargeValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
                
        // FIXME - Clean this up
        
        guard let entityType = entityType else { fatalError("entity not assigned, cannot continue") }
        
        let pickerDataSource = EntityPickerDataSource()
        self.pickerDataSource = pickerDataSource
        
        self.entityPicker.dataSource = self.pickerDataSource
        
        let pickerDelegate = EntityPickerDelegate(with: self.entityPicker.dataSource as! EntityPickerDataSource, tableView:tableView)
        pickerDelegate.titleLabel = self.entityName
        
        self.pickerDelegate = pickerDelegate
        self.entityPicker.delegate = pickerDelegate
        
        self.title = entityType.rawValue
        
        switch entityType {
        case .character:
            let tableViewDataSource  = CharacterTableViewDataSource()
            tableViewDataSource.tableViewHeightConstraint = tableViewHeightConstraint
            self.tableViewDataSource = tableViewDataSource
            tableView.dataSource = self.tableViewDataSource
            tableView.delegate   = self

            tableViewHeightConstraint.constant = tableViewDataSource.heightForTableView()
            
            Characters()
            
        case .starship:
            let tableViewDataSource = VehicleTableViewDataSource()
            tableView.dataSource = tableViewDataSource
            self.tableViewDataSource = tableViewDataSource
            tableViewHeightConstraint.constant = tableViewDataSource.heightForTableView()
            
            Starships();
            
        case .vehicle:
            let tableViewDataSource = VehicleTableViewDataSource()
            self.tableViewDataSource = tableViewDataSource
            tableView.dataSource = tableViewDataSource
            tableViewHeightConstraint.constant = tableViewDataSource.heightForTableView()
            
            Vehicles()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { fatalError("Identifier not set") }
        
        if identifier == "vehicleSegue" {
            if let destination = segue.destination as? AssociatedVehiclesController {
                let tableViewDataSource = self.tableViewDataSource as? CharacterTableViewDataSource
                destination.character = tableViewDataSource?.entity as? Character
                destination.vehicleType = self.selectedVehicleType
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 4 || indexPath.row == 5 {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // FIXME: - We need to take care of magic numbers
        if indexPath.row == 4 {
            let tableViewDataSource = self.tableViewDataSource as? CharacterTableViewDataSource
            guard let character = tableViewDataSource?.entity as? Character else { fatalError("We're accessing this on a vehicle or starship page") }
            
            if character.vehicleUrls.isEmpty {
                self.selectedVehicleType = .starships
            } else {
                self.selectedVehicleType = .vehicles
            }
            self.performSegue(withIdentifier: "vehicleSegue", sender: self)
        } else if indexPath.row == 5 {
            self.selectedVehicleType = .starships
            self.performSegue(withIdentifier: "vehicleSegue", sender: self)
        }
    }
    
    // Mark: - Data Pulling
    
    func Characters() {
        client.getCharacters(fromPage: self.currentPage) { characters, nextPage, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Data Error", message: "\(error)")
                    return
                }
                
                guard let pickerDataSource = self.pickerDataSource else { fatalError("Picker data source not established") }
                if pickerDataSource.isEmpty() {
                    let tableViewDataSource = self.tableView.dataSource as! CharacterTableViewDataSource
                    tableViewDataSource.entity = characters[0]
                    self.tableView.reloadData()
                    self.entityName.text = tableViewDataSource.entity?.name
                }
                
                pickerDataSource.update(with: characters)
                self.entityPicker.reloadAllComponents()
                
            }
            
            if nextPage != nil {
                self.currentPage += 1
                self.Characters()
            } else {
                DispatchQueue.main.async {
                    self.setQuickBar()
                }
            }
        }
    }
    
    func Vehicles() {
        client.getVehicles(fromPage: currentPage) { vehicles, nextPage, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Data Error", message: "\(error)")
                    return
                }
                guard let pickerDataSource = self.pickerDataSource else { fatalError("Picker data source not established") }
                
                if pickerDataSource.isEmpty() {
                    let tableViewDataSource = self.tableView.dataSource as! VehicleTableViewDataSource
                    tableViewDataSource.entity = vehicles[0]
                    self.tableView.reloadData()
                    self.entityName.text = tableViewDataSource.entity?.name
                }
                
                pickerDataSource.update(with: vehicles)
                self.entityPicker.reloadAllComponents()
            }
            
            if nextPage != nil {
                self.currentPage += 1
                self.Vehicles()
            } else {
                DispatchQueue.main.async {
                    self.setQuickBar()
                }
            }
            
        }
    }
    
    func Starships() {
        client.getStarships(fromPage: currentPage) { starships, nextPage, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Data Error", message: "\(error)")
                    return
                }
                guard let pickerDataSource = self.pickerDataSource else { fatalError("Picker data source not established") }
                
                if pickerDataSource.isEmpty() {
                    let tableViewDataSource = self.tableView.dataSource as! VehicleTableViewDataSource
                    tableViewDataSource.entity = starships[0]
                    self.tableView.reloadData()
                    self.entityName.text = tableViewDataSource.entity?.name
                }
                
                pickerDataSource.update(with: starships)
                self.entityPicker.reloadAllComponents()
            }
            
            if nextPage != nil {
                self.currentPage += 1
                self.Vehicles()
            } else {
                DispatchQueue.main.async {
                    self.setQuickBar()
                }
            }
        }
    }
    
    func setQuickBar() {
        guard let entityType = entityType else { fatalError("Entity type required") }
        let labels = [quickBarSmallKey, quickBarSmallValue, quickBarLargeKey, quickBarLargeValue]
        
        for label in labels {
            label?.isHidden = false
        }
        
        let dataSource = self.pickerDataSource
        
        do {
           let (smallest, largest) = try (dataSource?.largestAndSmallestBasedUponLength())!
            quickBarSmallKey.text = "Shortest"
            quickBarSmallValue.text = smallest.name
            switch entityType {
            case .character:
                quickBarLargeKey.text = "Tallest"
            case .vehicle, .starship:
                quickBarLargeKey.text = "Longest"
            }
            
            quickBarLargeValue.text = largest.name
        } catch SWAPIError.invalidData {
            showAlert(title: "Invalid Data")
        } catch {
            showAlert(title: "Error")
        }
    }
    
    // MARK: - Error handling
    
    // Function to add alerts for invalid data
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
