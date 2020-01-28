//
//  ShipmentInpost.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/20/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class ShipmentInpost: Shipment {
    
    enum CodingKeys: String, CodingKey {
        case id = "tracking_number"
        case service
        case origin
        case destination =  "custom_attributes"
        case status
        case events = "tracking_details"
        case status_timestamp = "updated_at"
    }
    
    enum CodingKeysCustomAtributes: String, CodingKey {
        
        case address
    }
    
    enum CodingKeysAddress: String, CodingKey {
        case line1, line2, line3
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.service = try container.decode(String.self, forKey: .service)
        
        let timestamp = try container.decode(String.self, forKey: .status_timestamp)
        let status = try container.decode(String.self, forKey: .status)
        self.status = EventInpost(status: status, timestamp: timestamp)
        
        //"tracking_details\":[{\"status\":\"delivered\",\"origin_status\":\"DOR\",\"agency\":null,\"datetime\":\"2020-01-15T07:51:16.000+01:00\"}
        
        do {
            let customAttributesContiner = try container.nestedContainer(keyedBy: CodingKeysCustomAtributes.self, forKey: .destination)
            let addressContainer = try customAttributesContiner.nestedContainer(keyedBy: CodingKeysAddress.self, forKey: .address)
            let lin1 = try addressContainer.decodeIfPresent(String.self, forKey: .line1) ?? ""
            let lin2 = try addressContainer.decodeIfPresent(String.self, forKey: .line2) ?? ""
            let lin3 = try addressContainer.decodeIfPresent(String.self, forKey: .line3) ?? ""
            let address = lin1 + " " + lin2 + " " + lin3
            self.destination = Place(countryCode: "PL", address: address)
        }
        catch {
            self.destination = nil
        }
        
        self.events = try container.decode([EventInpost].self, forKey: .events)
    }
}
