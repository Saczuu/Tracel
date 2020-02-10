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
    var interactor = Interactor()
    
    var services = ["DHL", "Inpost"]
    
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
                            self.isValidating.toggle()
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
        self.interactor.fetchPackageData(trackingNumber: self.trackingNumber, serviceProvider: ServiceProviders(rawValue: self.services[self.pickedService])! ) { (result) in
            switch result {
            case .success(let data):
                do {
                    
                    guard let shipment = try self.interactor.decodePackageIntoShipment(for: ServiceProviders(rawValue: self.services[self.pickedService])!, from: data) else {
                        return self.showError.toggle()
                    }
                    let package = Package(context: self.moc)
                    package.id = UUID()
                    package.tracking_number = self.trackingNumber
                    package.service_provider = self.services[self.pickedService]
                    package.desc = self.description
                    package.status_code = shipment.status.statusCode!.rawValue
                    try self.moc.save()
                    return self.presentationMode.wrappedValue.dismiss()
                }
                catch {
                    self.showError.toggle()
                }
            case .failure(_):
                self.showError.toggle()
            }
        }
    }
}

struct AddNewPackage_Previews: PreviewProvider {
    static var previews: some View {
        NewPackageView()
    }
}
