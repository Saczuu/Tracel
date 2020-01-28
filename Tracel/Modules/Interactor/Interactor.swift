//
//  Interactor.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/28/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Combine
import Foundation

class Interactor {
    
    func fetchPackageData(package: Package, result: @escaping (Result<Data, NetworkError>) -> Void) {
        switch ServiceProviders(rawValue: package.service_provider!) {
        case .dhl:
            guard let url = URL(string: "https://api-eu.dhl.com/track/shipments?trackingNumber=\(package.tracking_number!)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("mJMqYi1N0My5I6LYTiNH6c4URBhk8ZFG", forHTTPHeaderField: "DHL-API-Key")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    return result(.failure(.unableToFetch))
                }
                result(.success(data))
            }.resume()
        case .inpost:
            guard let url = URL(string: "https://api-shipx-pl.easypack24.net/v1/tracking/\(package.tracking_number!)?") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    return result(.failure(.unableToFetch))
                }
                result(.success(data))
            }.resume()
        case .none:
            result(.failure(.unableToFetch))
        }
    }
    
    func fetchInpostStatuses(result: @escaping (Result<StatusesInpost, NetworkError>) -> Void ){
        let url = URL(string: "https://api-shipx-pl.easypack24.net/v1/statuses")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            let json = JSONDecoder()
            do {
                let statuses = try! json.decode(StatusesInpost.self, from: data!)
                result(.success(statuses))
            } catch {
                result(.failure(NetworkError.unableToFetch))
            }
        }.resume()
    }
    
    // MARK: - Decoders for package
    func decodeDhlIntoShipment(from data: Data) -> Shipment {
        let json = JSONDecoder()
        let dhl = try! json.decode(DHL.self, from: data)
        return dhl.shipments.first!
    }
    
    func decodeInpostIntoShipment(from data: Data) -> Shipment {
        let json = JSONDecoder()
        return try! json.decode(ShipmentInpost.self, from: data)
    }
}
