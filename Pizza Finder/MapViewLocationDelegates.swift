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
        
        if canUpdate {
            guard let location = locations.last else { return }
            
            let calculatedBearing = getBearingBetweenTwoPoints(location1: (directions?.first?.startCoordinate)!, location2: (directions?.first?.endCoordinate)!)
            let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel, bearing: calculatedBearing, viewingAngle: self.viewingAngle)
            
            // Animate position of pin
            marker?.position = location.coordinate
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
            
            //check to see if I need to head to next waypoint
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
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    func getBearingBetweenTwoPoints(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double {
        let lat1 = location1.latitude
        let long1 = location1.longitude
        
        let lat2 = location2.latitude
        let long2 = location2.longitude
        
        let dlon = long1 - long2
        
        let x = cos(lat2) * sin(dlon)
        let y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon)
        
        let radiansBearing = atan2(x, y)
        
        return radiansToDegrees(radians: radiansBearing)
    }
}
