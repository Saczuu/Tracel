//
//  MapView.swift
//  Tracel
//
//  Created by Maciej Sączewski on 1/14/20.
//  Copyright © 2020 Maciej Sączewski. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        
    }
    //MARK: - TEMP
    //MARK: - Show MapView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        return Coordinator()
    }
}
// MARK: - Previews
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

