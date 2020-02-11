//
//  PackageDetailsView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/12/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct PackageDetailsView: View {
    
    let interactor: Interactor! = Interactor()
    
    var package: Package!
    
    @State var isLoading: Bool = true
    @State var shipment: Shipment? = nil
    
    var body: some View {
        List {
            if isLoading == false {
                VStack(alignment: .leading) {
                    MapView(origin: self.shipment?.origin, destination: self.shipment?.destination)
                        .frame(height: 300)
                        .padding([.top, .leading, .trailing], -20)
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
                .frame(minHeight: 800, maxHeight: .infinity)
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
        self.interactor.fetchPackageData(trackingNumber: package.tracking_number!, serviceProvider: ServiceProviders(rawValue: package.service_provider!)!) { response in
            switch response {
            case .failure(_) :
                print("Error with featching")
            case .success(let data) :
                self.shipment = try! self.interactor.decodePackageIntoShipment(for: ServiceProviders(rawValue: package.service_provider!)!, from: data)
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
