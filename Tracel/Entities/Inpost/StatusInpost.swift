//
//  StatusImpost.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/6/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class StatusImpost: Decodable {
    var status: EventInpost!
    
    enum CodingKeys: String, CodingKey {
        case status
        case status_timestamp = "updated_at"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let timestamp = try container.decode(String.self, forKey: .status_timestamp)
        let status = try container.decode(String.self, forKey: .status)
        self.status = EventInpost(status: status, timestamp: timestamp)
    }
}
