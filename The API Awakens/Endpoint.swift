//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var pageQueryItem: URLQueryItem { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = [pageQueryItem]
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum SWAPI {
    case characters(page: Int)
    case vehicles(page: Int)
    case starships(page: Int)
}

extension SWAPI: Endpoint {
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        switch self {
        case .characters: return "/api/people"
        case .vehicles: return "/api/vehicles"
        case .starships: return "/api/starships"
        }
    }
    
    var pageQueryItem: URLQueryItem {
        switch self {
        case .characters(let page):
            return URLQueryItem(name: "page", value: "\(page)")
        case .starships(let page):
            return URLQueryItem(name: "page", value: "\(page)")
        case .vehicles(let page):
            return URLQueryItem(name: "page", value: "\(page)")
        }
        
    }
    
    static func pageWith(url: String) -> URLRequest {
        let url = URL(string: url)!
        return URLRequest(url: url)
    }
}
