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
        
        case .ups:
            guard var url = URLComponents(string: "https://wwwcie.ups.com/rest/Track") else { return }
            let params = ["UPSSecurity": [
                "UsernameToken": [
                    "Username": "saczewski.maciej@outlook.com",
                    "Password": "zitki1-rUvtib-dicpup"],
                "ServiceAccessToken": [
                    "AccessLicenseNumber": "3D77E5B7220153D5"
                ]],
                          "TrackRequest": [
                            "Request": [
                                "RequestOption": "1",
                                "TransactionReference": [
                                    "CustomerContext": "Your Test Case Summary Description"
                                ]
                            ],
                            "InquiryNumber": "\(tracking_number!)"
                ]
            ]
            var request = URLRequest(url: url.url!)
            request.httpMethod = "POST"
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
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
