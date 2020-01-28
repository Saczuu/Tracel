//
//  ShipmentDetaliCard.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/28/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct ShipmentDetaliCard: View {
    let shipment: Shipment!
    var body: some View {
        VStack(alignment: .leading) {
            Text("Package number")
                .font(.subheadline)
            Text("\(shipment.id)")
                .font(.headline)
            Text("Service")
                .font(.footnote)
                .padding(.top, 5)
            Text(shipment.service.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter())
                .font(.subheadline)
            Divider()
            Text("Current status")
                .font(.headline)
            HStack {
                Text("\(shipment.status.description?.capitalizingFirstLetter() ?? "No event details")")
                Spacer()
            }
            HStack {
                Spacer()
                Text("\(shipment!.status.timestamp ?? "No given timestamp")")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ShipmentDetaliCard_Previews: PreviewProvider {
    static var previews: some View {
        ShipmentDetaliCard(shipment: Shipment())
    }
}
