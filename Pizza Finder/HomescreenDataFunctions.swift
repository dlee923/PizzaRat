//
//  HomescreenDataFunctions.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/1/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GoogleMaps

extension HomescreenVC: CLLocationManagerDelegate {

    func pullNearbyRestaurants(food: String) {
        
        var urlString: String?
        
        if let lat = currentPlace?.latitude, let long = currentPlace?.longitude {
            urlString = googleSearch.googleSearchString(metersRadius: 5000, isRankedByClosest: true, isRankedByType: .distance, latitude: lat, longitude: long, keyword: food.replacingOccurrences(of: " ", with: "%20"), openNow: true, type: "Restaurant")
        }
        
        googleSearch.retrieveData(htmlString: urlString!) { (restaurants) in
            self.restaurants = restaurants
        }
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted : print("Location access was restricted")
        case .denied : print("Location access was denied")
        case .notDetermined : print("Location access was not determined")
        case .authorizedWhenInUse :
            findCurrentPlace()
            print("Location access was authorized when in use")
        case .authorizedAlways :
            findCurrentPlace()
            print("Location access was authorized always")
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
                
                self.currentPlace = EstablishmentsObj(name: name, address: address, rating: rating, priceTier: priceTier, latitude: latitude, longitude: longitude, placeID: placeID, photoRef: "")
            }
        }
    }
    
}
