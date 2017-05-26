//
//  EstablishmentsObj.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/26/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation

class EstablishmentsObj: NSObject {

    var name: String?
    var address: String?
    var rating: Double?
    var priceTier: Int?
    var latitude: Double?
    var longitude: Double?
    
    init(name: String, address: String, rating: Double, priceTier: Int, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.rating = rating
        self.priceTier = priceTier
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
