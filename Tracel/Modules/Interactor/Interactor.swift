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
    
    // MARK: - Fetch data from API
    func fetchPackageData(trackingNumber: String, serviceProvider: ServiceProviders, result: @escaping (Result<Data, NetworkError>) -> Void) {
        switch serviceProvider {
        case .dhl:
            guard let url = URL(string: "https://api-eu.dhl.com/track/shipments?trackingNumber=\(trackingNumber)") else { return }
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
            guard let url = URL(string: "https://api-shipx-pl.easypack24.net/v1/tracking/\(trackingNumber)?") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    return result(.failure(.unableToFetch))
                }
                result(.success(data))
            }.resume()
        }
    }
    //FIXME: Temporary implementation of data request from UPS
    func fetchUPS() {
        //https://wwwcie.ups.com/rest/Track
        guard var url = URLComponents(string: "https://wwwcie.ups.com/rest/Track") else { return }
        let params = ["UPSSecurity": [
            "UsernameToken": [
                "Username": "saczewski.maciej@outlook.com",
                "Password": "zitki1-rUvtib-dicpup"],
            "ServiceAccessToken": [
                "AccessLicenseNumber": "Your Access License Number"
            ]],
                      "TrackRequest": [
                        "Request": [
                            "RequestOption": "1",
                            "TransactionReference": [
                                "CustomerContext": "Your Test Case Summary Description"
                            ]
                        ],
                        "InquiryNumber": "1Z9R5F466806049785"
            ]
        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: String.Encoding.utf8))
        }.resume()
    }
    
    // MARK: - INPOST status list request
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
    
    func decodePackageIntoShipment(for serviceProvider: ServiceProviders, from data: Data) throws -> Shipment? {
        switch serviceProvider {
        case .dhl:
            return try decodeDhlIntoShipment(from: data)
        case .inpost:
            return try decodeInpostIntoShipment(from: data)
        }
    }
    
    func decodePackageForStatus(for package: Package, from data: Data) throws -> Event? {
        switch ServiceProviders(rawValue: package.service_provider!) {
        case .dhl:
            return try decodeDhlIntoStatus(from: data)
            
        case .inpost:
            return try decodeInpostIntoStatus(from: data)
        case .none:
            return nil
        }
    }
    
    //MARK: - DHL decoders
    func decodeDhlIntoShipment(from data: Data) throws -> Shipment {
        let json = JSONDecoder()
        let dhl = try json.decode(DHL.self, from: data)
        return dhl.shipments.first!
    }
    
    func decodeDhlIntoStatus(from data: Data) throws -> Event {
        let shipment = try self.decodeDhlIntoShipment(from: data)
        return shipment.status
    }
    
    //MARK: - Inpost Decoders
    func decodeInpostIntoShipment(from data: Data) throws -> Shipment {
        let json = JSONDecoder()
        return try json.decode(ShipmentInpost.self, from: data)
    }
    
    func decodeInpostIntoStatus(from data: Data) throws -> Event {
        let json = JSONDecoder()
        let status =  try json.decode(StatusImpost.self, from: data)
        return status.status
    }
}
