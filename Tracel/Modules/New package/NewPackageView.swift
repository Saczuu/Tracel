//
//  NewPackageView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/17/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct NewPackageView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    var interactor = Interactor()
    
    var services = ["DHL", "Inpost"]
    
    @State var trackingNumber: String = ""
    @State var pickedService: Int = 0
    
    
    var body: some View {
        NavigationView {
            List {
                Text("Tracking number")
                TextField("Package ID", text: self.$trackingNumber)
                Picker(selection: self.$pickedService, label: Text("Service")) {
                    ForEach(0 ..< services.count) {
                        Text(self.services[$0])
                    }
                }
                HStack {
                    Button(action: {
                        if self.trackingNumber != "" {
                            self.saveNewPackage()
                        }
                    }) {
                        Text("Add new package")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Add package"))
        }
    }
    
    func saveNewPackage() {
        let package: Package = Package(context: self.moc)
        package.id = UUID()
        package.tracking_number = self.trackingNumber
        package.service_provider = self.services[self.pickedService]
        self.interactor.fetchPackageData(package: package) { (result) in
            switch result {
            case .success(let data):
                do {
                    switch ServiceProviders(rawValue: self.services[self.pickedService]) {
                    case .dhl:
                        _ = self.interactor.decodeDhlIntoShipment(from: data)
                        try! self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    case .inpost:
                        _ = self.interactor.decodeInpostIntoShipment(from: data)
                        try! self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    case .none:
                        print("To handle")
                    }
                }
                catch {
                    print("To handle")
                }
            case .failure(_):
                print("To handle")
                
            }
        }
    }
}

struct AddNewPackage_Previews: PreviewProvider {
    static var previews: some View {
        NewPackageView()
    }
}
