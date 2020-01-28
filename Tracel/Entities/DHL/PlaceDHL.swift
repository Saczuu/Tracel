//
//  PlaceDHL.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/13/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceDHL: Place {
    
    enum CodingKeysAddress: String, CodingKey {
        case address
    }
    
    enum CodingKeysPlace: String, CodingKey {
        case countryCode, addressLocality
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeysAddress.self)
        let addressContainer = try container.nestedContainer(keyedBy: CodingKeysPlace.self, forKey: .address)
        
        self.countryCode = try addressContainer.decodeIfPresent(String.self, forKey: .countryCode) ?? "nil"
        self.addressLocality = try addressContainer.decodeIfPresent(String.self, forKey: .addressLocality) ?? "nil"
    }
    
}
