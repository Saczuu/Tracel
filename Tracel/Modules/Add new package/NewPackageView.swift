//
//  NewPackageView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/17/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI

struct NewPackageView: View {
    
    //Environment to dismiss view
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @State var packageNumber: String = ""
    
    var body: some View {
        VStack {
            Text("Add new package to track")
                .padding(.top, 100)
            Text("Package number:")
            TextField("Package number", text: $packageNumber)
            Button(action: {
                if (self.packageNumber != "") {
                    self.checkDhlParcel(with: self.packageNumber) { result in
                        print(result)
                        if result {
                            let package = Package(context: self.moc)
                            package.id = UUID()
                            package.service_provider = "DHL"
                            package.tracking_number = self.packageNumber
                            try? self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.packageNumber = ""
                        }
                    }
                }
            }) {
                Text("Save")
            }
        }
    }
    
    func checkDhlParcel(with parcelID: String, result:  @escaping (Bool)->Void) {
        guard let url = URL(string: "https://api-eu.dhl.com/track/shipments?trackingNumber=\(parcelID)") else { return  result(false)}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("mJMqYi1N0My5I6LYTiNH6c4URBhk8ZFG", forHTTPHeaderField: "DHL-API-Key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            do {
                try decoder.decode(DHL.self, from: data!)
                result(true)
            } catch {
                result(false)
            }
        }.resume()
    }
}

struct AddNewPackage_Previews: PreviewProvider {
    static var previews: some View {
        NewPackageView()
    }
}
