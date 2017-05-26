//
//  ResultsVC.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/26/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import GooglePlaces

class ResultsVC: GMSAutocompleteResultsViewController, GMSAutocompleteResultsViewControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
        setUpResultsVC()
    }
    
    var searchController: UISearchController?
    var resultView: UITextView?
    
    func setUpResultsVC() {
        searchController = UISearchController(searchResultsController: self)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
    }
    
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print(String(describing: error.localizedDescription))
    }
    
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
