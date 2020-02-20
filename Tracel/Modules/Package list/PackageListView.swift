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
    @State var isLoading: Bool = false
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Package.entity(), sortDescriptors: []) var packages: FetchedResults<Package>
    
    var statusIcons = ["pre-transit":"envelope",
                       "transit": "cube.box",
                       "delivered":"checkmark",
                       "failure": "exclamationmark.triangle.fill",
                       "unknown": "questionmark.circle.fill"]
    var iconColors = ["pre-transit":Color.blue,
                      "transit": .orange,
                      "delivered": .green,
                      "failure": .red,
                      "unknown": .yellow]
    
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
                            self.updatePackage(package)
                        }
                    }
                }
                .onDelete(perform: self.removePackage)
            }
            .onPull(perform: {
                self.isLoading.toggle()
                self.packages.map { self.updatePackage($0)}
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading.toggle()
                }
            }, isLoading: isLoading)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showModalNewPacakageView = true
                }) {
                    Image(systemName: "plus")
                }.sheet(isPresented: self.$showModalNewPacakageView, content: {
                    NewPackageView().environment(\.managedObjectContext, self.moc)
                }))
            .navigationBarTitle("Your Packages")
        }
    }
    
    func removePackage(at offsets: IndexSet) {
        for offset in offsets{
            let package = packages[offset]
            moc.delete(package)
        }
        
        try? moc.save()
    }
    
    func updatePackage(_ package: Package) {
        package.fetchPackageData() { (result) in
            switch result {
            case .success(let data):
                let status = try? data.decodePackageForStatus(for: package)
                package.status_code = status!.statusCode?.rawValue
                try! self.moc.save()
            case .failure(_):
                return
            }
        }
    }
}
