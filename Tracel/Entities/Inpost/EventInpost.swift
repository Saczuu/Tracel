//
//  EventInpost.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/28/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class EventInpost: Event {
    
    enum CodingKeys: String, CodingKey {
        case datetime, status
    }
    
    init(status: String, timestamp: String) {
        super.init()
        self.timestamp = timestamp
        self.status = status
        
        let interactor = Interactor()
        interactor.fetchInpostStatuses { (result) in
            switch result {
            case .success(let fetchedStatuses):
                for fetchedStatus in fetchedStatuses.items {
                    if fetchedStatus["name"] == status {
                        self.description = fetchedStatus["title"]
                    }
                }
            case .failure(_):
                print("error")
                self.status = "Unknown"
                self.description = "Unknown"
            }
        }
        
        if self.status == "delivered" || self.status!.contains("ready_to_pickup"){
            self.statusCode = StatusCode.delivered
        } else if self.status == "created" || self.status == "confirmed" || self.status == "collected_from_sender" {
            self.statusCode = .pretransit
        } else if self.status!.contains("undelivered") {
            self.statusCode = .failure
        } else {
            self.statusCode = .unknown
        }
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.status = try! container.decode(String.self, forKey: .status)
        self.timestamp = try! container.decode(String.self, forKey: .datetime)
        
        let interactor = Interactor()
        interactor.fetchInpostStatuses { (result) in
            switch result {
            case .success(let fetchedStatuses):
                for fetchedStatus in fetchedStatuses.items {
                    if fetchedStatus["name"] == self.status {
                        self.description = fetchedStatus["title"]
                    }
                }
            case .failure(_):
                self.status = "Unknown"
                self.description = "Unknown"
            }
        }
        
        if self.status == "delivered" || self.status!.contains("ready_to_pickup") {
            self.statusCode = StatusCode.delivered
        } else if self.status == "created" || self.status == "confirmed" || self.status == "collected_from_sender" {
            self.statusCode = .pretransit
        } else if self.status!.contains("undelivered") {
            self.statusCode = .failure
        } else {
            self.statusCode = .unknown
        }
        
        
    }
}
