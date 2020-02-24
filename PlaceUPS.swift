//
//  PlaceUPS.swift
//  Tracel
//
//  Created by Maciej Sączewski on 24/02/2020.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class PlaceUPS: Place {
    
    var type: String!
    
    enum PlaceKeys: String, CodingKey {
        case Address // Origin and destinatioon containers
        case type = "Type"//01- origin, 02- destination
    }
    enum AddressKeys: String, CodingKey {
        case AddressLine, PostalCode, City, CountryCode
    }
    enum TypeKeys: String, CodingKey {
        case Code
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: PlaceKeys.self)
        let addressContainer = try container.nestedContainer(keyedBy: AddressKeys.self, forKey: .Address)
        self.countryCode = try addressContainer.decode(String.self, forKey: .CountryCode)
        
        let addressLine = try addressContainer.decodeIfPresent(String.self, forKey: .AddressLine) ?? ""
        let postalCode = try addressContainer.decodeIfPresent(String.self, forKey: .PostalCode) ?? ""
        let city = try addressContainer.decodeIfPresent(String.self, forKey: .City) ?? ""
        self.addressLocality = addressLine+", "+postalCode+" "+city
        
        let typeContiner = try container.nestedContainer(keyedBy: TypeKeys.self, forKey: .type)
        self.type = try typeContiner.decode(String.self, forKey: .Code)
    }
}
