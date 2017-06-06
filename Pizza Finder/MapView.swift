//
//  MapView.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/3/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GoogleMaps

class MapView: GMSMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    var zoomLevel: Float = 15
    var viewingAngle: Double = 30
    var bearing: Double = 0
    
    var currentPlace: EstablishmentsObj?
    var pizzaPlace: EstablishmentsObj?
    var directions: [WayPoint]?
    
    var iconSize: CGFloat = 50
    lazy var pizzaIcon: UIImageView = {
        let pizza = UIImageView()
        pizza.image = UIImage(named: "Pizza")
        pizza.frame.size = CGSize(width: self.iconSize, height: self.iconSize)
        return pizza
    }()
    
    lazy var ratIcon: UIImageView = {
        let rat = UIImageView()
        rat.image = UIImage(named: "Rat")
        rat.frame.size = CGSize(width: self.iconSize, height: self.iconSize)
        return rat
    }()
    
    func setUpMap(currentPosition: EstablishmentsObj, pizzaPlace: EstablishmentsObj, showsCurrentPositionBtn: Bool) {
        let latitude = CLLocationDegrees(currentPosition.latitude!)
        let longitude = CLLocationDegrees(currentPosition.longitude!)
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(latitude, longitude), zoom: zoomLevel, bearing: bearing, viewingAngle: viewingAngle)
        self.camera = camera
//        GMSMapView.map(withFrame: self.bounds, camera: camera)
//        self.isHidden = true
        self.settings.myLocationButton = showsCurrentPositionBtn
        self.settings.tiltGestures = true
        
        pinMapLocation(currentPlace: currentPosition, pizzaPlace: pizzaPlace)
    }
    
    var marker: GMSMarker?
    
    func pinMapLocation(currentPlace: EstablishmentsObj, pizzaPlace: EstablishmentsObj) {
        self.clear()
        
        if currentPlace != nil && pizzaPlace != nil {
            let currentPlaceLat = CLLocationDegrees(exactly: currentPlace.latitude!)
            let currentPlaceLong = CLLocationDegrees(exactly: currentPlace.longitude!)
            let currentPlaceCoordinate = CLLocationCoordinate2DMake(currentPlaceLat!, currentPlaceLong!)
            
            let pizzaLat = CLLocationDegrees(exactly: pizzaPlace.latitude!)
            let pizzaLong = CLLocationDegrees(exactly: pizzaPlace.longitude!)
            let pizzaCoordinate = CLLocationCoordinate2DMake(pizzaLat!, pizzaLong!)
            
            marker = GMSMarker(position: currentPlaceCoordinate)
            marker?.iconView = ratIcon
            marker?.snippet = currentPlace.address
            marker?.title = currentPlace.name
            marker?.map = self
            
            let pizzaMarker = GMSMarker(position: pizzaCoordinate)
            pizzaMarker.iconView = pizzaIcon
            pizzaMarker.snippet = pizzaPlace.address
            pizzaMarker.title = pizzaPlace.name
            pizzaMarker.map = self
        }
    }
    
    func traceDirection(wayPoints: [WayPoint]) {
        let path = GMSMutablePath()
        for point in wayPoints {
            path.addLatitude(point.startCoordinate.latitude, longitude: point.startCoordinate.longitude)
        }
        
        guard let endPoint = wayPoints.last?.endCoordinate else { return }
        
        path.addLatitude(endPoint.latitude, longitude: endPoint.longitude)
        
        let directionsPath = GMSPolyline(path: path)
        
        let strokeColor = UIColor.purple
        let strokeWidth: CGFloat = 5
        
        directionsPath.strokeColor = strokeColor
        directionsPath.strokeWidth = strokeWidth
        directionsPath.map = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
