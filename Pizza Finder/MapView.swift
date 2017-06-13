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
    var selectedPlace: EstablishmentsObj?
    var assortedPlaces: [EstablishmentsObj]?
    var directions: [WayPoint]?
    
    var marker: GMSMarker?
    var mapViewVC: MapViewVC?
    
    let buttonSize: CGFloat = 30
    
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
    
    func setUpMap(currentPosition: EstablishmentsObj, assortedPlaces: [EstablishmentsObj], showsCurrentPositionBtn: Bool) {
        let latitude = CLLocationDegrees(currentPosition.latitude!)
        let longitude = CLLocationDegrees(currentPosition.longitude!)
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(latitude, longitude), zoom: zoomLevel, bearing: bearing, viewingAngle: viewingAngle)
        self.camera = camera
//        GMSMapView.map(withFrame: self.bounds, camera: camera)
//        self.isHidden = true
        self.settings.myLocationButton = showsCurrentPositionBtn
        self.settings.tiltGestures = true
        
        pinMapLocation(currentPlace: currentPosition, assortedPlaces: assortedPlaces)
        
        setUpBackButton(buttonSize: buttonSize, function: #selector(returnToEstablishmentsVC), view: self, target: self)
    }
    
    func returnToEstablishmentsVC() {
        mapViewVC?.dismiss(animated: true, completion: nil)
    }
    
    func pinMapLocation(currentPlace: EstablishmentsObj, assortedPlaces: [EstablishmentsObj]) {
        self.clear()
        
        if currentPlace != nil && assortedPlaces != nil {
            let currentPlaceLat = CLLocationDegrees(exactly: currentPlace.latitude!)
            let currentPlaceLong = CLLocationDegrees(exactly: currentPlace.longitude!)
            let currentPlaceCoordinate = CLLocationCoordinate2DMake(currentPlaceLat!, currentPlaceLong!)
            
            marker = GMSMarker(position: currentPlaceCoordinate)
            marker?.iconView = ratIcon
            marker?.snippet = currentPlace.address
            marker?.title = currentPlace.name
            marker?.map = self
            
            for eachPlace in assortedPlaces {
                let placeLat = CLLocationDegrees(exactly: eachPlace.latitude!)
                let placeLong = CLLocationDegrees(exactly: eachPlace.longitude!)
                let placeCoordinate = CLLocationCoordinate2DMake(placeLat!, placeLong!)
                
                let placeMarker = GMSMarker(position: placeCoordinate)
                placeMarker.iconView = pizzaIcon
                placeMarker.snippet = eachPlace.address
                placeMarker.title = eachPlace.name
                placeMarker.map = self
            }
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
