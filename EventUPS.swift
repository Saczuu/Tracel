//
//  EventUPS.swift
//  Tracel
//
//  Created by Maciej Sączewski on 24/02/2020.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class EventUPS: Event {
    
    enum ActivityKeys: String, CodingKey {
        case Date, Status, Time
    }
    
    enum StatusKeys: String, CodingKey {
        case Description
    
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: ActivityKeys.self)
        let statusContainer = try container.nestedContainer(keyedBy: StatusKeys.self, forKey: .Status)
        self.description = try statusContainer.decode(String.self, forKey: .Description)
        self.status = description
        
        if self.description == "Delivered" {
            self.statusCode = .delivered
        } else if self.description!.contains("Out For") || self.description!.contains("Scan"){
            self.statusCode = .transit
        } else if self.description!.contains("Order") || self.description!.contains("Ready") || self.description!.contains("Origin") {
            self.statusCode = .pretransit
        } else {
            self.statusCode = .unknown
        }
        //FIXME:- Format timestamp field in propper way to unified dataformatter
        let date = try container.decode(String.self, forKey: .Date)
        let time = try container.decode(String.self, forKey: .Time)
        self.timestamp = date+"U"+time
        
        
        
    }
}
