//
//  Place.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/20/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class Place: Decodable {
    var countryCode: String?
    var addressLocality: String?
    
    init() { }
    
    init(countryCode: String, address: String) {
        self.countryCode = countryCode
        self.addressLocality = address
    }
}
