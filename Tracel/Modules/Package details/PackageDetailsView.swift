//
//  PackageDetailsView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/12/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct PackageDetailsView: View {
    
    var package: Package!
    
    @State var isLoading: Bool = true
    @State var shipment: Shipment? = nil
    
    var body: some View {
        List {
            if isLoading == false {
                VStack(alignment: .leading) {
                    ZStack {
                        MapView(origin: self.shipment?.origin, destination: self.shipment?.destination)
                            .frame(height: 300)
                            .padding([.top, .leading, .trailing], -20)
                        if shipment?.origin == nil && shipment?.destination == nil  {
                            HStack {
                                Spacer()
                                Text("No information about destination or origin")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                Spacer()
                            }
                        .background(
                            Color.black.frame(height:125).padding([.leading, .trailing], -25)
                        )
                        }
                    }
                    .frame(minWidth: 100, maxWidth: .infinity + 100)
                    ShipmentDetaliCard(shipment: self.shipment!)
                    HStack {
                        Spacer()
                        ShipmentGraph(statusCode: shipment!.status!.statusCode ?? StatusCode.unknown)
                        Spacer()
                    }
                    ShipmentHistoryList(shipment: self.shipment!)
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: self.$isLoading, style: .medium)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(minHeight: 1000, maxHeight: .infinity)
            }
        }
        .navigationBarTitle(Text("Package details"))
        .onAppear {
            self.decodeShipment(package: self.package)
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    func decodeShipment(package: Package) {
        package.fetchPackageData() { response in
            switch response {
            case .failure(_) :
                print("Error with featching")
            case .success(let data) :
                self.shipment = try! data.decodePackageIntoShipment(for: package)
                self.package.status_code = self.shipment!.status.statusCode?.rawValue
                self.isLoading.toggle()
            }
        }
    }
}

struct PackageDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PackageDetailsView()
    }
}
