//
//  File.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/20/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import Foundation

class Shipment: Decodable {
    var id: String!
    var service: String!
    var origin: Place?
    var destination: Place!
    var events: [Event]?
    var status: Event!
    
    init(){
        
    }
}
