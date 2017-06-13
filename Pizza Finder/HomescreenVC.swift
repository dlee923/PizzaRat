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
        self.view.backgroundColor = .white
        
        setUpView()
        setUpPickerView()
        
        // Find current coordinates
        findCurrentPlace()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        
    }
    
    var numberOfRestaurants = 3
    
    let foodChoicesPickerHeight: CGFloat = 100
    
    let foodChoicesPickerBottomBuffer: CGFloat = 20
    
    let durationColorBackground = 0.25
    
    let backgroundColorAlpha: CGFloat = 0.75
    
    var nightMode: Bool = false
    
    lazy var foodChoices: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.backgroundColor = self.choices.first?.backgroundColor.withAlphaComponent(self.backgroundColorAlpha)
        view.isPagingEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var foodChoicesPicker: ChoicesPickerView = {
        let picker = ChoicesPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.homescreenVC = self
        picker.isUserInteractionEnabled = false
        return picker
    }()
    
    func setUpView() {
        self.view.addSubview(foodChoices)
        foodChoices.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        foodChoices.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        foodChoices.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        foodChoices.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        foodChoices.register(ChoicesCell.self, forCellWithReuseIdentifier: choicesCellID)
    }
    
    func setUpPickerView() {
        self.view.addSubview(foodChoicesPicker)
        
        foodChoicesPicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        foodChoicesPicker.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.2).isActive = true
        foodChoicesPicker.widthAnchor.constraint(equalToConstant: foodChoicesPickerHeight).isActive = true
        foodChoicesPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: (self.view.frame.height / 2) - (foodChoicesPickerHeight / 2) - foodChoicesPickerBottomBuffer).isActive = true
        
    }
    
    let choicesCellID = "choicesCell"
    
    let choices = [ChoicesObj(type: "Pizza", imageName: "PizzaImg", backgroundColor: .orange, optionImageName: "optionPizza"),
                   ChoicesObj(type: "Chicken", imageName: "ChickenImg", backgroundColor: .purple, optionImageName: "optionChicken"),
                   ChoicesObj(type: "Meatballs", imageName: "MeatballsImg", backgroundColor: .red, optionImageName: "optionMeatball"),
                   ChoicesObj(type: "Halal", imageName: "HalalImg", backgroundColor: .yellow, optionImageName: "optionHalal"),
                   ChoicesObj(type: "Ice Cream", imageName: "IceCreamImg", backgroundColor: .blue, optionImageName: "optionIceCream"),
                   ChoicesObj(type: "Burgers", imageName: "burgerImg", backgroundColor: .green, optionImageName: "optionBurger"),
                   ChoicesObj(type: "Tacos", imageName: "tacoImg", backgroundColor: .white, optionImageName: "optionTaco")]
    
    let googleSearch = GoogleSearch()
    
    var currentPlace: EstablishmentsObj? {
        didSet { }
    }
    var restaurants: [EstablishmentsObj]? {
        didSet {
            for eachRestaurant in restaurants! {
                eachRestaurant.downloadDirections(origin: (currentPlace?.coordinate)!, destination: eachRestaurant.coordinate!)
            }
            // should bring up map with restaurants visible
            let presentingMapView = MapViewVC()            
            presentingMapView.currentPlace = self.currentPlace
            if let restaurants = (self.restaurants?.prefix(numberOfRestaurants)) {
                let restaurantOptions = Array(restaurants)
                presentingMapView.selectedPlace = restaurantOptions.last
                presentingMapView.assortedPlaces = restaurantOptions
            }
            fadeOutTransition(viewControllerToPresent: presentingMapView, viewControllerPresenting: self)
        }
    }
    
    let placesClient = GMSPlacesClient.shared()
    
    func instantiateSplashScreen() {
        let splashScreen = SplashScreenVC()
        self.present(splashScreen, animated: false, completion: nil)
    }
    
    let searchVC = SearchVC()
    
    func presentSearchAutoComplete() {
        present(searchVC, animated: true, completion: nil)
    }
}






