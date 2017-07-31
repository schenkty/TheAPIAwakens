//
//  SWAPIError.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation

enum SWAPIError: Error {
    case requestFailed
    case invalidData
    case jsonParsingFailure(message: String)
    case responseUnsuccessful
    case jsonConversionFailure
}
