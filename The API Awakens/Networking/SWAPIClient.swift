//
//  SWAPIClient.swift
//  The API Awakens
//
//  Created by Ty Schenk on 7/30/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation

class SWAPIClient {
    let downloader = JSONDownloader()
    
    func getCharacters(fromPage pageId: Int, completion: @escaping ([Character], String?, Error?) -> Void) {
        let endpoint = SWAPI.characters(page: pageId)
        performRequest(with: endpoint) { json, nextPage, error in
            guard let json = json else {
                completion([], nil, error)
                return
            }
            
            do {
                let characters = try json.flatMap { try Character.init(from: $0) }
                completion(characters, nextPage, nil)
            } catch (let characterError) {
                completion([], nil, characterError)
            }
            
        }
    }
    
    func getVehicles(fromPage pageId: Int, completion: @escaping ([Vehicle], String?, Error?) -> Void) {
        let endpoint = SWAPI.vehicles(page: pageId)
        performRequest(with: endpoint) { json, nextPage, error in
            guard let json = json else {
                completion([], nil, error)
                return
            }
            
            do {
                let vehicles = try json.flatMap { try Vehicle.init(from: $0) }
                completion(vehicles, nextPage, nil)
            } catch (let vehicleError) {
                completion([], nil, vehicleError)
            }
        }
      
    }
    
    func getVehicle(fromURL url: String, completion: @escaping (Vehicle?, Error?) -> Void) {
        let endpoint = SWAPI.pageWith(url: url)
        let task = downloader.jsonTask(with: endpoint) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                do {
                    let vehicle = try Vehicle.init(from: json)
                    completion(vehicle, nil)
                } catch (let vehicleError) {
                    completion(nil, vehicleError)
                }
            }
        }
        
        task.resume()
    }
    
    func getStarships(fromPage pageId: Int, completion: @escaping ([Vehicle], String?, Error?) -> Void) {
        let endpoint = SWAPI.starships(page: pageId)
        performRequest(with: endpoint) { json, nextPage, error in
            guard let json = json else {
                completion([], nil, error)
                return
            }
            
            do {
                let starships = try json.flatMap { try Vehicle.init(from: $0) }
                completion(starships, nextPage, nil)
            } catch (let starshipError) {
                completion([], nil, starshipError)
            }
            
        }
    }
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping ([[String: AnyObject]]?, String?, SWAPIError?) -> Void) {
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                
                guard let json = json else {
                    completion(nil, nil, error)
                    return
                }
                
                guard let results = json["results"] as? [[String: AnyObject]] else {
                    completion(nil, nil, .jsonParsingFailure(message: "Does not contain results"))
                    return
                }
                
                guard let nextPage = json["next"] as? String else {
                    completion(results, nil, nil)
                    return
                }
                
                completion(results, nextPage, nil)
            }
        }
        
        task.resume()
    }
}
