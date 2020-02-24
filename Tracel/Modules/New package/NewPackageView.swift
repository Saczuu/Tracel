//
//  NewPackageView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/17/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI
import CoreData

struct NewPackageView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var services = ["DHL", "Inpost", "UPS"]
    
    @State var description: String = ""
    @State var trackingNumber: String = ""
    @State var pickedService: Int = 0
    
    @State var isValidating: Bool = false
    @State var showError: Bool = false
    @State var showSuccess: Bool = false
    
    var body: some View {
        NavigationView {
            if isValidating {
                Loading(rotateIndicator: self.isValidating,
                        showCompletion: self.showSuccess,
                        showError: self.showError,
                        errorString: "Unable to find your package, check your tracking number",
                        onErrorHandler: {
                            self.showError.toggle()
                            return self.isValidating.toggle()
                }, onSuccessHandler: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                    .padding()
            } else {
                List {
                    Text("Description")
                    TextField("Package description", text: self.$description)
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
                                self.isValidating.toggle()
                                self.saveNewPackage(package_number: self.trackingNumber, service_provider: self.services[self.pickedService])
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
    }
    
    func saveNewPackage(package_number: String, service_provider: String) {
        let package = Package(context: self.moc)
        package.id = UUID()
        package.tracking_number = self.trackingNumber
        package.service_provider = self.services[self.pickedService]
        package.desc = self.description
        package.status_code = "unknown"
        do {
            package.fetchPackageData() { (result) in
                switch result {
                case .success(let data):
                    do {
                        
                        guard let shipment = try data.decodePackageIntoShipment(for: package) else {
                            return self.showError.toggle()
                        }
                        package.status_code = shipment.status.statusCode!.rawValue
                        try self.moc.save()
                        return self.presentationMode.wrappedValue.dismiss()
                    }
                    catch {
                        self.moc.delete(package)
                        self.showError.toggle()
                    }
                case .failure(_):
                    self.moc.delete(package)
                    self.showError.toggle()
                }
            }
        }
    }
}
