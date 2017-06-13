//
//  EstablishmentCard.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/4/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension UILabel {
    func genericLabel(fontSize: CGFloat, fontColor: UIColor, alignment: NSTextAlignment) {
        self.font = fontReno?.withSize(fontSize)
        self.textAlignment = alignment
        self.textColor = fontColor
    }
}

class EstablishmentCard: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        
    }
    
    var cardHeight: CGFloat?
    var cardWidth: CGFloat?
    
    var cardCenter: CGPoint?
    var touchPoint: CGPoint?
    var superTouchPoint: CGPoint?
    var xDifference: CGFloat?
    var yDifference: CGFloat?
    
    let cardSpeed: Double = 0.2
    let edgeTarget: CGFloat = 0.25
    let desiredRotationAngle: CGFloat = 30
    let verticalSwing: CGFloat = 0.2
    let photoSizeMultiplier: CGFloat = 0.9
    
    var underLyingCard: EstablishmentCard?
    var establishmentChoicesVC: EstablishmentChoicesVC?
    
    func setUpCard() {
        self.addSubview(photo)
        photo.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: photoSizeMultiplier).isActive = true
        photo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: photoSizeMultiplier).isActive = true
        photo.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        photo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(name)
        name.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        name.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
        name.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10).isActive = true
        name.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(street)
        street.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        street.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
        street.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0).isActive = true
        street.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        for x in 0...4 {
            let priceImage: UIImageView = {
                let image = UIImageView()
                image.contentMode = .scaleAspectFit
                image.translatesAutoresizingMaskIntoConstraints = false
                return image
            }()
            
            self.addSubview(priceImage)
            priceImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
            priceImage.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
            priceImage.topAnchor.constraint(equalTo: street.bottomAnchor, constant: 10).isActive = true
            let xValue = ((cardWidth! * 0.5) / 2.0) + ((cardWidth! * 0.1) * CGFloat(x))
            print(xValue)
            priceImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: xValue).isActive = true
            
            priceImage.image = x <= self.establishment.priceTier! ? UIImage(named: "priceFilled") : UIImage(named: "priceUnfilled")
        }
        
        addTapGesture()
    }
    
    let googleSearch = GoogleSearch()
    var establishment: EstablishmentsObj! {
        didSet {
            name.text = self.establishment.name
            street.text = self.establishment.address
            rating.text = "\(self.establishment.rating)"
            googleSearch.downloadDirections(origin: currentLocation.coordinate!, destination: establishment.coordinate!, TravelMode: .walking) { (directions) in
                self.directions = directions
            }
            setUpCard()
        }
    }
    
    var currentLocation: EstablishmentsObj!
    
    var directions: [WayPoint]?
    
    lazy var photo: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = self.cardWidth! * 0.3 / 2
        image.pullRestaurantPhoto(establishment: self.establishment)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
