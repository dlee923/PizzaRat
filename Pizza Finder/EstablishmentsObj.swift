//
//  EstablishmentsObj.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/26/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import CoreLocation

class EstablishmentsObj: NSObject {

    var name: String?
    var address: String?
    var rating: Double?
    var priceTier: Int?
    var latitude: Double?
    var longitude: Double?
    var placeID: String?
    var coordinate: CLLocationCoordinate2D?
    var photoRef: String?
    var directions: [WayPoint]?
    
    init(name: String, address: String, rating: Double, priceTier: Int, latitude: Double, longitude: Double, placeID: String, photoRef: String) {
        self.name = name
        let parsedAddress = address.components(separatedBy: ",")
        self.address = parsedAddress.first
        self.rating = rating
        self.priceTier = priceTier
        self.latitude = latitude
        self.longitude = longitude
        self.placeID = placeID        
        self.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        self.photoRef = photoRef
        self.directions = [WayPoint]()
    }
}

extension EstablishmentsObj {
    func downloadDirections(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        GoogleSearch().downloadDirections(origin: origin, destination: destination, TravelMode: .walking) { (downloadedDirections) in
            self.directions = downloadedDirections
        }
    }
}

struct ChoicesObj {
    var type: String
    var imageName: String
    var backgroundColor: UIColor
    var optionImageName: String
}
