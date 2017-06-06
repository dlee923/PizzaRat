//
//  MapViewVC.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/28/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps

class MapViewVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var mapView = MapView()
    
    var zoomLevel: Float = 15

    var currentPlace: EstablishmentsObj? {
        didSet { mapView.currentPlace = self.currentPlace }
    }
    var pizzaPlace: EstablishmentsObj? {
        didSet { mapView.pizzaPlace = self.pizzaPlace }
    }
    var directions: [WayPoint]? {
        didSet {
            mapView.directions = self.directions
            mapView.setUpMap(currentPosition: self.currentPlace!, pizzaPlace: self.pizzaPlace!, showsCurrentPositionBtn: true)
            mapView.traceDirection(wayPoints: self.directions!)
            mapView.frame = self.view.bounds
            self.view.addSubview(mapView)
            requestAuth()
        }
    }
    
    var marker: GMSMarker?
    
    let locationManager = CLLocationManager()
    
    func requestAuth() {
        
        marker = mapView.marker
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}
