//
//  PackageListView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/7/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct PackageListView: View {
    
    @State var showModalNewPacakageView: Bool = false
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Package.entity(), sortDescriptors: []) var packages: FetchedResults<Package>
    var interactor = Interactor()
    
    var statusIcons = ["pretransit":"envelope",
                       "transit": "cube.box",
                       "delivered":"checkmark",
                       "failure": "exclamationmark.triangle.fill",
                       "unknown": "exclamationmark.triangle.fill"]
    var iconColors = ["pretransit":Color.blue,
                      "transit": .orange,
                      "delivered": .green,
                      "failure": .red,
                      "unknown": .red]
    init() {
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach (packages, id: \.id) { package in
                    NavigationLink(destination: PackageDetailsView(package: package)) {
                        HStack {
                            Image(systemName: self.statusIcons[package.status_code!]!)
                                .resizable()
                                .foregroundColor(.white)
                                .background(Circle().fill(self.iconColors[package.status_code!]!).frame(width: 50, height: 50))
                                .frame(width: 30, height: 30)
                                .padding()
                            VStack(alignment: .leading) {
                                Text("\(package.desc  ?? "No description")")
                                HStack {
                                    Text("\(package.tracking_number ?? "Unknown tracking number")")
                                        .font(.footnote)
                                    Spacer()
                                    Text("\(package.service_provider ?? "Unknown service provider")")
                                        .font(.footnote)
                                }
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100)
                        .onAppear {
                            self.interactor.fetchPackageData(trackingNumber: package.tracking_number!, serviceProvider: ServiceProviders(rawValue: package.service_provider!)!) { (result) in
                                switch result {
                                case .success(let data):
                                    let status = try? self.interactor.decodePackageForStatus(for: package, from: data)
                                    package.status_code = status!.statusCode?.rawValue
                                case .failure(_):
                                    return
                                }
                            }
                        }
                    }
                }.onDelete(perform: removePackage)
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.showModalNewPacakageView = true
                }) {
                    Image(systemName: "plus")
                }.sheet(isPresented: self.$showModalNewPacakageView, content: {
                    NewPackageView().environment(\.managedObjectContext, self.moc)
                }))
                .navigationBarTitle("Your Package")
        }
    }
    
    func removePackage(at offsets: IndexSet) {
        for offset in offsets{
            let package = packages[offset]
            moc.delete(package)
        }
        
        try? moc.save()
    }
}

struct PackageListView_Previews: PreviewProvider {
    static var previews: some View {
        PackageListView()
    }
}
