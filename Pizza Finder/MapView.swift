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
    
    var currentPlace: EstablishmentsObj?
    var selectedPlace: EstablishmentsObj?
    var assortedPlaces: [EstablishmentsObj]?    
    
    var marker: GMSMarker?
    var mapViewVC: MapViewVC?
    
    let buttonSize: CGFloat = 30
    var iconSize: CGFloat = 50
    let directionsPathThickness: CGFloat = 5
    
    lazy var foodIcon: UIImageView = {
        let food = UIImageView()
        food.image = UIImage(named: "Pizza")
        food.frame.size = CGSize(width: self.iconSize, height: self.iconSize)
        return food
    }()
    
    lazy var ratIcon: UIImageView = {
        let rat = UIImageView()
        rat.image = UIImage(named: "Rat")
        rat.frame.size = CGSize(width: self.iconSize, height: self.iconSize)
        return rat
    }()
    
    func setUpMap(currentPosition: EstablishmentsObj, assortedPlaces: [EstablishmentsObj], showsCurrentPositionBtn: Bool, foodType: String, zoom: Float, bearing: CLLocationDirection, viewingAngle: Double) {
        
        let camera = GMSCameraPosition.camera(withTarget: (selectedPlace?.coordinate)!, zoom: zoom, bearing: bearing, viewingAngle: viewingAngle)
        self.camera = camera
        self.settings.myLocationButton = showsCurrentPositionBtn
        self.settings.tiltGestures = true
        
        pinMapLocations(currentPlace: currentPosition, assortedPlaces: assortedPlaces, foodType: foodType)
        
        setUpBackButton(buttonSize: buttonSize, function: #selector(returnToEstablishmentsVC), view: self, target: self)
    }
    
    func returnToEstablishmentsVC() {
        mapViewVC?.dismiss(animated: true, completion: nil)
    }
    
    func pinMapLocations(currentPlace: EstablishmentsObj, assortedPlaces: [EstablishmentsObj], foodType: String) {
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
                foodIcon.image = UIImage(named: foodType)
                placeMarker.iconView = foodIcon
                placeMarker.snippet = eachPlace.address
                placeMarker.title = eachPlace.name
                placeMarker.map = self
                
                eachPlace.mapMarker = placeMarker
            }
            
            self.selectedMarker = selectedPlace?.mapMarker
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
        let strokeWidth: CGFloat = directionsPathThickness
        
        directionsPath.strokeColor = strokeColor
        directionsPath.strokeWidth = strokeWidth
        directionsPath.map = self
        
        if let myLocation = currentPlace?.coordinate {
            self.animate(toLocation: (wayPoints.first?.startCoordinate)!)
            self.animate(toZoom: (mapViewVC?.directionsZoomLevel)!)
            self.animate(toViewingAngle: (mapViewVC?.directionsViewingAngle)!)
            let calculatedBearing = mapViewVC?.getBearingBetweenTwoPoints(location1: (wayPoints.first?.startCoordinate)!, location2: (wayPoints.first?.endCoordinate)!)
            self.animate(toBearing: calculatedBearing!)
        }
        mapViewVC?.directions = wayPoints
        mapViewVC?.canUpdate = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
