//
//  MapViewLocationDelegates.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/30/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension MapViewVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel)
        
        // Animate position of pin
        marker?.position = location.coordinate
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted : print("Location access was restricted")
        case .denied : print("Location access was denied")
        case .notDetermined : print("Location access was not determined")
        case .authorizedWhenInUse : print("Location access was authorized when in use")
        case .authorizedAlways : print("Location access was authorized always")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(String(describing: error.localizedDescription))
    }
    
}
