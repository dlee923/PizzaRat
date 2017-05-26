//
//  ViewController.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/25/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import GooglePlaces

class HomescreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .red
        requestAuth()
        googleSearch.executeSearch(metersRadius: 5000, isRankedByClosest: true, isRankedByType: .distance, latitude: googleSearch.nycLatitude, longitude: googleSearch.nycLongitude, keyword: "Pizza", openNow: true, type: "Restaurant")
//        findCurrentPlace()
//        presentSearchAutoComplete()
//        presentResultsAutoComplete()
    }
    
    let googleSearch = GoogleSearch()
    
    let placesClient = GMSPlacesClient.shared()
    let locationManager = CLLocationManager()
    
    func requestAuth() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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
            print("Current Place name \(String(describing: place.name))")
            print("Current Place address \(String(describing: place.formattedAddress))")
            print("Current Place attributions \(String(describing: place.attributions))")
            print("Current PlaceID \(String(describing: place.placeID))")
            }
        }
    }
    
    let searchVC = SearchVC()
    
    func presentSearchAutoComplete() {
        present(searchVC, animated: true, completion: nil)
    }
    
    let resultsVC = ResultsVC()
    
    func presentResultsAutoComplete() {
        present(resultsVC, animated: true, completion: nil)
    }
}

