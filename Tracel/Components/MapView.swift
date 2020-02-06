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
    
    var origin: Place?
    var destination: Place?
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
    }
    //MARK: - Show MapView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if origin != nil {
            self.showOrigin(view: uiView)
        }
        if destination != nil {
            self.showDestination(view: uiView)
        }
        
        uiView.showAnnotations(uiView.annotations, animated: false)
    }
    
    func showOrigin(view: MKMapView) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.origin!.addressLocality!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = self.origin!.addressLocality!
            annotation.subtitle = "Origin"
            view.addAnnotation(annotation)
            view.showAnnotations(view.annotations, animated: false)
        }
    }
    
    func showDestination(view: MKMapView) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.destination!.addressLocality!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = self.destination!.addressLocality!
            annotation.subtitle = "Destination"
            view.addAnnotation(annotation)
            view.showAnnotations(view.annotations, animated: false)
        }
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
