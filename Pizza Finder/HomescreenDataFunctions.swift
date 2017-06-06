//
//  HomescreenDataFunctions.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/1/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GoogleMaps

extension HomescreenVC {

    func pullNearbyRestaurants(food: String) {
        let urlString = googleSearch.executeSearch(metersRadius: 5000, isRankedByClosest: true, isRankedByType: .distance, latitude: googleSearch.nycLatitude, longitude: googleSearch.nycLongitude, keyword: food, openNow: true, type: "Restaurant")
        googleSearch.retrieveData(htmlString: urlString) { (restaurants) in
            self.restaurants = restaurants
        }
    }
    
    func downloadDirections(destination: CLLocationCoordinate2D) {
        if let origin = currentPlace?.coordinate {
            googleSearch.downloadDirections(origin: origin, destination: destination, TravelMode: .walking) { wayPointsArray in
                self.directions = wayPointsArray
            }
        }
    }
    
    func findCurrentPlace() {
        placesClient.currentPlace { (places, err) in
            if err != nil {
                let error = err?.localizedDescription
                print(error)
                return
            }
            
            if let placesList = places {
                guard let place = placesList.likelihoods.first?.place else { return }
                
                let name = place.name
                guard let address = place.formattedAddress else { return }
                let rating = Double(place.rating)
                let priceTier = place.priceLevel.rawValue
                let latitude = place.coordinate.latitude
                let longitude = place.coordinate.longitude
                let placeID = place.placeID
                print("Current Place name \(String(describing: name))")
                print("Current Place address \(String(describing: address))")
                print("Current Place attributions \(String(describing: place.attributions))")
                print("Current PlaceID \(String(describing: placeID))")
                print("Current Place Latitude Coordinate \(String(describing: latitude))")
                print("Current Place Longitude Coordinate \(String(describing: longitude))")
                
                self.currentPlace = EstablishmentsObj(name: name, address: address, rating: rating, priceTier: priceTier, latitude: latitude, longitude: longitude, placeID: placeID)
            }
        }
    }
    
}
