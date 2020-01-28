//
//  ShipmentGraph.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/14/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct ShipmentGraph: View {
    
    var statusCode: StatusCode!
    
    var body: some View {
        HStack{
            Image(systemName: "envelope")
                .foregroundColor(.white)
                .background(Circle().fill(Color.blue).scaleEffect(2.5))
                .overlay(Circle().fill(Color.gray).opacity(statusCode == StatusCode.pretransit ? 0 : 0.6).scaleEffect(2.5))
            next
            Image(systemName: "cube.box")
                .foregroundColor(.white)
                .background(Circle().fill(Color.orange).scaleEffect(2.5))
                .overlay(Circle().fill(Color.gray).opacity(statusCode == StatusCode.transit ? 0 : 0.6).scaleEffect(2.5))
            next
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
                .background(Circle().fill(Color.red).scaleEffect(2.5))
                .overlay(Circle().fill(Color.gray).opacity(statusCode == StatusCode.failure ? 0 : 0.6).scaleEffect(2.5))
            next
            Image(systemName: "checkmark")
                .foregroundColor(.white)
                .background(Circle().fill(Color.green).scaleEffect(2.5))
                .overlay(Circle().fill(Color.gray).opacity(statusCode == StatusCode.delivered ? 0: 0.6).scaleEffect(2.5))
        }
    }
    
    var next: some View {
        Image(systemName: "chevron.right")
            .padding()
    }
}


struct ShipmentGraph_Previews: PreviewProvider {
    static var previews: some View {
        ShipmentGraph(statusCode: .delivered)
    }
}
