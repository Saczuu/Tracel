//
//  EventDHL.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/14/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation


class EventDHL: Event {
    
    enum CodingKeys: String, CodingKey {
        case timestamp, status, description, statusCode
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? nil
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? nil
        let statusCodeRawValue = try container.decodeIfPresent(String.self, forKey: .statusCode) ?? nil
        self.statusCode = StatusCode(rawValue: statusCodeRawValue!) ?? StatusCode.unknown
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? nil
    }
}
