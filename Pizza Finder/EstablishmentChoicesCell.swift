//
//  EstablishmentChoicesCell.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/2/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import GoogleMaps

extension UILabel {
    func genericLabel(fontSize: CGFloat, fontColor: UIColor, alignment: NSTextAlignment) {
        self.font = fontReno?.withSize(fontSize)
        self.textAlignment = alignment
        self.textColor = fontColor
    }
}

class EstablishmentChoicesCell: BaseCell {
    
    override func setUpCell() {
        self.addSubview(cardView)
        cardView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        cardView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        setUpMap(view: cardView)

        cardView.addSubview(name)
        name.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.1).isActive = true
        name.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.75).isActive = true
        name.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 10).isActive = true
        name.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
    }
    
    func setUpMap(view: UIView) {
        view.addSubview(map)
        map.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        map.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        map.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -map.frame.height).isActive = true
    }
    
    let googleSearch = GoogleSearch()
    var establishment: EstablishmentsObj! {
        didSet {
            name.text = self.establishment.name
            street.text = self.establishment.address
            price.text = "\(self.establishment.priceTier)"
            rating.text = "\(self.establishment.rating)"
        }
    }
    
    var currentLocation: EstablishmentsObj! {
        didSet {
            googleSearch.downloadDirections(origin: currentLocation.coordinate!, destination: establishment.coordinate!, TravelMode: .walking) { (directions) in
                self.directions = directions
            }
        }
    }
    
    var directions: [WayPoint]? {
        didSet {
            map.setUpMap(currentPosition: self.currentLocation, pizzaPlace: self.establishment, showsCurrentPositionBtn: false)
            map.traceDirection(wayPoints: self.directions!)
        }
    }
    
    lazy var map: MapView = {
        let view = MapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 15, fontColor: .black, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var street: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 15, fontColor: .blue, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 15, fontColor: .blue, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rating: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 15, fontColor: .blue, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = .red
        return view
    }()
}
