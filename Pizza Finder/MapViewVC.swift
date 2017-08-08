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
        mapView.frame = self.view.bounds
        self.view.addSubview(mapView)
        setUpEstablishmentsView()
//        requestAuth()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canUpdate = false
    }
    
    override func viewDidLayoutSubviews() {
        showCardsButton.transparentButton(text: "Return To All Locations", fontSize: 12, borderWidth: 8, xInset: 5, yInset: 5, alpha: 0.9, color: .orange)
    }
        
    var zoomLevel: Float = 14
    var directionsZoomLevel: Float = 18
    var viewingAngle: Double = 30
    var directionsViewingAngle: Double = 65
    // 16+ max degree is 65, 10- max degree is 30
    var bearing: Double = 0
    var canUpdate = false

    let mapView = MapView()
    
    var currentPlace: EstablishmentsObj? {
        didSet { mapView.currentPlace = self.currentPlace }
    }
    var selectedPlace: EstablishmentsObj? {
        didSet {  }
    }
    var assortedPlaces: [EstablishmentsObj]? {
        didSet {
            mapView.selectedPlace = self.selectedPlace
            mapView.assortedPlaces = self.assortedPlaces
            if let _currentPlace = self.currentPlace, let _assortedPlaces = self.assortedPlaces {
                mapView.setUpMap(currentPosition: _currentPlace, assortedPlaces: _assortedPlaces, showsCurrentPositionBtn: true, foodType: "Pizza", zoom: zoomLevel, bearing: bearing, viewingAngle: viewingAngle)
            }
        }
    }
    var directions: [WayPoint]?
    
    lazy var establishmentsView: EstablishmentsView = {
        let view = EstablishmentsView()
        view.mapViewVC = self
        view.translatesAutoresizingMaskIntoConstraints = false        
        return view
    }()
    
    let showCardsButton: SeeAllEstablishments = {
        let button = SeeAllEstablishments(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var establishmentsViewYPosition: NSLayoutConstraint?
    var showCardsButtonXPosition: NSLayoutConstraint?
    
    func setUpEstablishmentsView() {
        self.view.addSubview(establishmentsView)
        establishmentsView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        establishmentsView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        establishmentsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        establishmentsViewYPosition = establishmentsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.frame.height * 0.25)
        establishmentsViewYPosition?.isActive = true
        
        establishmentsView.viewWidth = self.view.frame.width * 1
        establishmentsView.viewHeight = self.view.frame.width * 0.25
        
        establishmentsView.assortedPlaces = self.assortedPlaces
        
        self.view.addSubview(showCardsButton)
        showCardsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        showCardsButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        showCardsButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        showCardsButtonXPosition = showCardsButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.view.frame.width * 0.125)
        showCardsButtonXPosition?.isActive = true
    }
    
    func slideCardView(isUp: Bool) {
        
        if isUp {
            showCardsButtonXPosition?.constant = -self.view.frame.width * 0.75
        } else {
            establishmentsViewYPosition?.constant = self.view.frame.height * 0.25
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            print("establishments view y position is \(self.establishmentsViewYPosition?.constant)")
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
            if isUp {
                self.establishmentsViewYPosition?.constant = 0
                print("Slide card UP")
            } else {
                self.showCardsButtonXPosition?.constant = self.view.frame.width * 0.125
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                print("establishments view y position is \(self.establishmentsViewYPosition?.constant)")
                self.view.layoutIfNeeded()
            })
        })    
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
    
    deinit {
        print("deinit mapVC")
    }
}
