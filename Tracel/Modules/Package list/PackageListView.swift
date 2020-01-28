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
    
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        VStack{
            NavigationView {
                List {
                    ForEach (packages, id: \.id) { package in
                        NavigationLink(destination: PackageDetailsView(package: package)) {
                            Text(package.tracking_number ?? "Unknown tracking number")
                            Text(package.service_provider ?? "Unknow service provider")
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
