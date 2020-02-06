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
            try! self.decodeShipment(package: self.package)
//            self.interactor.fetchUPS()
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    func decodeShipment(package: Package) {
        self.interactor.fetchPackageData(package: package) { response in
            switch response {
            case .failure(_) :
                print("Error with featching")
            case .success(let data) :
                switch ServiceProviders(rawValue: self.package.service_provider!) {
                case .inpost :
                    self.shipment = try! self.interactor.decodeInpostIntoShipment(from: data)
                    self.isLoading.toggle()
                case .dhl :
                    self.shipment = try! self.interactor.decodeDhlIntoShipment(from: data)
                    self.isLoading.toggle()
                case .none:
                    print("Error")
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
