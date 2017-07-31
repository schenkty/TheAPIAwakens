//
//  EntityTableViewDataSource.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit

protocol EntityTableViewDataSource {
    var entity: Entity? { get set }
    var numberOfRows: CGFloat { get set }
    var heightOfRows: CGFloat { get set }
}

extension EntityTableViewDataSource {
    func heightForTableView() -> CGFloat {
        return heightOfRows * numberOfRows
    }
}
