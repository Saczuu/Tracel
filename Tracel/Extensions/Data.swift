//
//  Data.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/18/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
    
    //MARK:- Decoders
    func decodePackageIntoShipment(for package: Package) throws -> Shipment? {
        switch ServiceProviders(rawValue: package.service_provider!) {
        case .dhl:
            return try decodeDhlIntoShipment(from: self)
        case .inpost:
            return try decodeInpostIntoShipment(from: self)
        case .none:
            return nil
        }
    }
    
    func decodePackageForStatus(for package: Package) throws -> Event? {
        switch ServiceProviders(rawValue: package.service_provider!) {
        case .dhl:
            return try decodeDhlIntoStatus(from: self)
        case .inpost:
            return try decodeInpostIntoStatus(from: self)
        case .none:
            return nil
        }
    }
    
    //MARK: - DHL decoders
    private func decodeDhlIntoShipment(from data: Data) throws -> Shipment {
        let json = JSONDecoder()
        let dhl = try json.decode(DHL.self, from: data)
        return dhl.shipments.first!
    }
    
    private func decodeDhlIntoStatus(from data: Data) throws -> Event {
        let shipment = try self.decodeDhlIntoShipment(from: data)
        return shipment.status
    }
    
    //MARK: - Inpost Decoders
    private func decodeInpostIntoShipment(from data: Data) throws -> Shipment {
        let json = JSONDecoder()
        return try json.decode(ShipmentInpost.self, from: data)
    }
    
    private func decodeInpostIntoStatus(from data: Data) throws -> Event {
        let json = JSONDecoder()
        let status =  try json.decode(StatusImpost.self, from: data)
        return status.status
    }
}
