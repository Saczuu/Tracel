//
//  Package.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/20/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

extension Package {
    //MARK:- Data fetch from shimpent services api
    func fetchPackageData(result: @escaping (Result<Data, NetworkError>) -> Void) {
        switch ServiceProviders(rawValue: service_provider!) {
        case .dhl:
            guard let url = URL(string: "https://api-eu.dhl.com/track/shipments?trackingNumber=\(tracking_number!)") else { return }
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
            guard let url = URL(string: "https://api-shipx-pl.easypack24.net/v1/tracking/\(tracking_number!)?") else { return }
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
}
