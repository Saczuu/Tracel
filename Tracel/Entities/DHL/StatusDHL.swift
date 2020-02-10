//
//  StatusDHL.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/6/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class StatusDHL: Decodable {
    
    var status: EventDHL!
    
    enum CodingKeys: String, CodingKey {
        case status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(EventDHL.self, forKey: .status)
    }
}
