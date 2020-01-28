//
//  ShipmentDHL.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/13/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class ShipmentDHL: Shipment {
    
    
    enum CodingKeys: String, CodingKey {
        case id, service, origin, destination, status, events
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.service = try container.decode(String.self, forKey: .service)
        self.origin = try container.decode(PlaceDHL.self, forKey: .origin)
        self.destination = try container.decode(PlaceDHL.self, forKey: .destination)
        self.status = try container.decode(EventDHL.self, forKey: .status)
        self.events = try container.decodeIfPresent([EventDHL].self, forKey: .events) ?? nil
    }
}
