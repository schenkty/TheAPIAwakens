//
//  EntityPickerDelegate.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

class EntityPickerDelegate: NSObject, UIPickerViewDelegate {
    weak var dataSource: EntityPickerDataSource?
    weak var tableView: UITableView?
    weak var titleLabel: UILabel?
    
    override init() {
        super.init()
    }
    
    convenience init(with primaryDataSource: EntityPickerDataSource, tableView: UITableView) {
        self.init()
        self.dataSource = primaryDataSource
        self.tableView = tableView
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataSource = dataSource else { fatalError("Delegate cannot be initialized") }
        return dataSource.entity(at: row).name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard var tableViewDataSource = self.tableView?.dataSource as? EntityTableViewDataSource else {
            fatalError("Data source not found")
        }
        
        if let entity = self.dataSource?.entity(at: row), let label = self.titleLabel {
            tableViewDataSource.entity = entity
            self.tableView?.reloadData()
            label.text = entity.name
        }
        
    }
}
