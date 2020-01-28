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
                        self.saveNewPackage()
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
        package.tracking_number = self.trackingNumber
        package.service_provider = self.services[self.pickedService]
        self.interactor.fetchPackageData(package: package) { (result) in
            switch result {
            case .success(_):
                try! self.moc.save()
                self.presentationMode.wrappedValue.dismiss()
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
