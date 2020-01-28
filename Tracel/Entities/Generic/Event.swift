//
//  Event.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/20/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class Event: Decodable {
    var timestamp: String?
    var statusCode: StatusCode?
    var status: String?
    var description: String?
    
    init() { }
    
    init(timestamp: String, status: String, description: String) {
        self.timestamp = timestamp
        self.status = status
        self.description = description
        self.statusCode = .delivered
    }
}
