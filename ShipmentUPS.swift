//
//  ShipmentUPS.swift
//  Tracel
//
//  Created by Maciej Sączewski on 24/02/2020.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class ShipmentUPS: Shipment {
    
    enum ResponseKeys: String, CodingKey {
        case TrackResponse
    }
    enum TrackResponseKeys: String, CodingKey {
        case Shipment
    }
    
    enum ShipmentKeys: String, CodingKey {
        case Package
        case Service
        case ShipmentAddress
    }
    
    enum PackageKeys: String, CodingKey {
        case TrackingNumber
        case Activity // Events conatiner (first is current status)
    }
    
    enum ServiceKeys: String, CodingKey {
        case Description
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let responseContainer = try decoder.container(keyedBy: ResponseKeys.self)
        let trackResponseContainer = try responseContainer.nestedContainer(keyedBy: TrackResponseKeys.self, forKey: .TrackResponse)
        let shipmentContainer = try trackResponseContainer.nestedContainer(keyedBy: ShipmentKeys.self, forKey: .Shipment)
        let packageContainer = try shipmentContainer.nestedContainer(keyedBy: PackageKeys.self, forKey: .Package)
        
        // Filling fileds
        self.id = try packageContainer.decode(String.self, forKey: .TrackingNumber)
        
        let serviceContainer = try shipmentContainer.nestedContainer(keyedBy: ServiceKeys.self, forKey: .Service)
        self.service = try serviceContainer.decode(String.self, forKey: .Description)
        
        let address: [PlaceUPS] = try shipmentContainer.decode([PlaceUPS].self, forKey: .ShipmentAddress)
        self.origin = address.first(where: {$0.type == "01"})
        self.destination = address.first(where: {$0.type == "02"})
        
        self.events = try packageContainer.decode([EventUPS].self, forKey: .Activity)
        self.status = self.events!.first
        
    }
}
