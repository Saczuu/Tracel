//
//  StatusCodeDHL.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/14/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

enum StatusCode: String, Decodable{
    case pretransit = "pre-transit"
    case transit = "transit"
    case delivered = "delivered"
    case failure = "failure"
    case unknown = "unknown"
}

extension StatusCode: RawRepresentable {
    init?(rawValue: (String)) {
        switch rawValue {
        case ("pre-transit"): self = .pretransit
        case ("transit"): self = .transit
        case ("delivered"): self = .delivered
        case ("failure"): self = .failure
        case ("unknown"):  self = .unknown
        default: return nil
        }
    }
    
    var rawValue: (String) {
        switch self {
        case .pretransit: return ("pre-transit")
        case .transit: return ("transit")
        case .delivered: return ("delivered")
        case .failure: return ("failure")
        case .unknown: return ("unknown")
        }
    }
}
