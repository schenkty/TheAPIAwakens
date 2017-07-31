//
//  EntityPickerDataSource.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//
import UIKit

class EntityPickerDataSource: NSObject, UIPickerViewDataSource {
    private var data = [Entity]()
    
    override init() {
        super.init()
    }
    
    func update(with data: [Entity]) {
        self.data.append(contentsOf: data)
    }
    
    func entity(at index: Int) -> Entity {
        return data[index]
    }
    
    func isEmpty() -> Bool {
        return data.isEmpty
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func largestAndSmallestBasedUponLength() throws -> (largest: Entity, smallest: Entity) {
        var clonedData = [Entity]()
        
        for entity in data {
            if entity.length == "unknown" {
                continue
            }
            
            clonedData.append(entity)
        }
        
        let sorted = clonedData.sorted {
            let length1 = Float($0.length)!
            let length2 = Float($1.length)!
            
            return length1 < length2
        }
        guard let first = sorted.first else {
            throw SWAPIError.invalidData
        }
        
        guard let last = sorted.last else {
            throw SWAPIError.invalidData
        }
        
        return (first, last)
    }
}
