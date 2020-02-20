//
//  ShipmentHistoryList.swift
//  Tracel
//
//  Created by Maciej Sączewski on 2/11/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct ShipmentHistoryList: View {
    
    let shipment: Shipment!
    
    var body: some View {
        VStack(alignment: .leading){
            Text("History of package")
                .font(.headline)
                .padding(.bottom, 10)
            ForEach (shipment!.events!, id: \.timestamp) { event in
                VStack {
                    HStack {
                        Text("\(event.description ?? "No event details")")
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    HStack {
                        Spacer()
                        Text("\(event.timestamp ?? "No given timestamp")")
                            .font(.system(size: 8))
                            .foregroundColor(.gray)
                    }
                    Divider()
                }
            }
        }
    }
}

struct ShipmentHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        ShipmentHistoryList(shipment: Shipment())
    }
}
