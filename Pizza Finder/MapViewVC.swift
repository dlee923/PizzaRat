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
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.mapViewVC = self
        mapView.setUpMap(currentPosition: self.currentPlace!, assortedPlaces: self.assortedPlaces!, showsCurrentPositionBtn: true)
        mapView.frame = self.view.bounds
        self.view.addSubview(mapView)
        requestAuth()
    }
    
    var mapView = MapView()
    
    var zoomLevel: Float = 15

    var currentPlace: EstablishmentsObj? {
        didSet { mapView.currentPlace = self.currentPlace }
    }
    var selectedPlace: EstablishmentsObj? {
        didSet { mapView.selectedPlace = self.selectedPlace }
    }
    var assortedPlaces: [EstablishmentsObj]? {
        didSet { mapView.assortedPlaces = self.assortedPlaces }
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
