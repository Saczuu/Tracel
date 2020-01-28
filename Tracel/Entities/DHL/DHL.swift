//
//  DHL.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/13/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation
 
struct DHL: Decodable{
    var shipments: [ShipmentDHL]
    enum CodingKeys: String, CodingKey{
        case shipments
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shipments = try values.decode([ShipmentDHL].self, forKey: .shipments)
    }
}
