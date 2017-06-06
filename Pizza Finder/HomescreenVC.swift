//
//  ViewController.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 5/25/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class HomescreenVC: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpView()
        
        // Find current coordinates
//        findCurrentPlace()
    }
    
    lazy var foodChoices: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.backgroundColor = .red
        view.isPagingEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    func setUpView() {
        self.view.addSubview(foodChoices)
        foodChoices.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        foodChoices.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        foodChoices.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        foodChoices.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        foodChoices.register(ChoicesCell.self, forCellWithReuseIdentifier: choicesCellID)
    }
    
    let durationColorBackground = 0.25
    
    var nightMode: Bool = false
    
    let choicesCellID = "choicesCell"
    
    let choices = [ChoicesObj(type: "Pizza", imageName: "PizzaImg", backgroundColor: UIColor.orange),
                   ChoicesObj(type: "Chicken", imageName: "ChickenImg", backgroundColor: .purple),
                   ChoicesObj(type: "Meatballs", imageName: "MeatballsImg", backgroundColor: .red),
                   ChoicesObj(type: "Halal", imageName: "HalalImg", backgroundColor: .yellow),
                   ChoicesObj(type: "Ice Cream", imageName: "IceCreamImg", backgroundColor: .blue)]
    
    let googleSearch = GoogleSearch()
    
    var currentPlace: EstablishmentsObj? {
        didSet { }
    }
    var restaurants: [EstablishmentsObj]? {
        didSet {
            // should bring up establishment choices
            let presentingEstablishmentsView = EstablishmentChoicesCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
            presentingEstablishmentsView.establishments = Array((self.restaurants?.prefix(3))!)
            presentingEstablishmentsView.currentLocation = self.currentPlace
            self.navigationController?.pushViewController(presentingEstablishmentsView, animated: true)
            // then call the following function upon selection
            // selectedRestaurant = restaurants?.first
        }
    }
    var selectedRestaurant: EstablishmentsObj? {
        didSet {
            if let coordinate = selectedRestaurant?.coordinate {
                downloadDirections(destination: coordinate)
            }
        }
    }
    var directions: [WayPoint]? {
        didSet {
            print("restaurant count in array: \(restaurants?.count)")
            let presentingMapView = MapViewVC()
            presentingMapView.currentPlace = self.currentPlace
            presentingMapView.pizzaPlace = self.selectedRestaurant
            presentingMapView.directions = self.directions
            print("presenting")
            self.navigationController?.pushViewController(presentingMapView, animated: true)
        }
    }
    
    let placesClient = GMSPlacesClient.shared()
    

    
    let searchVC = SearchVC()
    
    func presentSearchAutoComplete() {
        present(searchVC, animated: true, completion: nil)
    }
    
    let resultsVC = ResultsVC()
    
    func presentResultsAutoComplete() {
        present(resultsVC, animated: true, completion: nil)
    }
}






