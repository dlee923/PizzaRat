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
    
    let cardSpeed: Double = 0.4
    let edgeTarget: CGFloat = 0.25
    let desiredRotationAngle: CGFloat = 30
    let verticalSwing: CGFloat = 0.2
    let photoSizeMultiplier: CGFloat = 0.4
    
    var establishmentsView: EstablishmentsView?
    var mapViewVC: MapViewVC?
    
    let googleSearch = GoogleSearch()
    var establishment: EstablishmentsObj! {
        didSet {
            name.text = self.establishment.name
            street.text = self.establishment.address
            rating.text = "\(self.establishment.rating)"
            setUpCard()
        }
    }
    
    func setUpCard() {
        self.addSubview(photo)
        photo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: photoSizeMultiplier).isActive = true
        photo.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: photoSizeMultiplier).isActive = true
        photo.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        photo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        
        self.addSubview(name)
        name.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: photoSizeMultiplier / 2).isActive = true
        name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 0).isActive = true
        name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        name.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        self.addSubview(street)
        street.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: photoSizeMultiplier / 2).isActive = true
        street.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 0).isActive = true
        street.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        street.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 0).isActive = true
        
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
    
    lazy var photo: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = (self.cardHeight! * self.photoSizeMultiplier) / 2
        image.clipsToBounds = true
        image.pullRestaurantPhoto(establishment: self.establishment)
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 12, fontColor: .black, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var street: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 12, fontColor: .blue, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 12, fontColor: .blue, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var rating: UILabel = {
        let label = UILabel()
        label.genericLabel(fontSize: 12, fontColor: .blue, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
