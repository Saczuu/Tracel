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
        ZStack {
            ActivityIndicator(isAnimating: $isLoading, style: .medium)
            if isLoading == false {
                List {
                    VStack(alignment: .leading) {
                        MapView()
                            .frame(height: 300)
                            .padding([.top, .leading, .trailing], -20)
                        ShipmentDetaliCard(shipment: self.shipment!)
                        HStack {
                            Spacer()
                            ShipmentGraph(statusCode: shipment!.status!.statusCode ?? StatusCode.unknown)
                            Spacer()
                        }
                        HStack {
                            Text("History of package")
                                .font(.headline)
                            Spacer()
                        }.padding(.bottom, 10)
                        if (shipment!.events != nil) {
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
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("Package details")
            }
        }
        .onAppear {
            //            self.trackDhlParcel(with: self.packageNumber)
            self.interactor.fetchPackageData(package: self.package) { response in
                switch response {
                case .failure(_) :
                    print("Error with featching")
                case .success(let data) :
                    switch ServiceProviders(rawValue: self.package.service_provider!) {
                    case .inpost :
                        self.shipment = self.interactor.decodeInpostIntoShipment(from: data)
                        self.isLoading.toggle()
                    case .dhl :
                        self.shipment = self.interactor.decodeDhlIntoShipment(from: data)
                        self.isLoading.toggle()
                    case .none:
                        print("Error")
                    }
                }
            }
        }
    }
}

struct PackageDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PackageDetailsView()
    }
}
