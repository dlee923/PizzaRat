//
//  EstablishmentsView.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/14/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class EstablishmentsView: UIView {

    var currentPlace: EstablishmentsObj? {
        didSet {  }
    }
    var selectedPlace: EstablishmentsObj? {
        didSet {  }
    }
    var assortedPlaces: [EstablishmentsObj]? {
        didSet {
            setUpCards(numberOfCards: assortedPlaces?.count ?? 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
                self.mapViewVC?.slideCardView(isUp: true)
                
                // test on device to see if I need this.
                print("")
            }
        }
    }
    
    var viewWidth: CGFloat?
    var viewHeight: CGFloat?
    var mapViewVC: MapViewVC?
    
    let cardSize: CGFloat = 0.7
    let maxCardSize: CGFloat = 0.85
    let popCardSpeed = 0.25
    
    var colors: [UIColor] = [.orange, .red, .green, .gray, .yellow]
    var establishmentCards: [EstablishmentCard]?
    
    func setUpCards(numberOfCards: Int) {
        for x in 0..<numberOfCards {
            let card: EstablishmentCard = {
                let view = EstablishmentCard()
                view.establishmentsView = self                
                view.mapViewVC = mapViewVC
                view.backgroundColor = colors[x]
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            self.addSubview(card)
            
            if x == numberOfCards - 1 {
                cardLayoutConstraints(card: card, size: maxCardSize, identifier: "\(x)")
            } else {
                cardLayoutConstraints(card: card, size: cardSize, identifier: "\(x)")
            }
        
            card.establishment = self.assortedPlaces?.reversed()[x]
        }
    }
    

    
    func removeConstraints(view: UIView, identifier: String) {
        let viewsConstraints = view.constraints.filter { (constraint) -> Bool in
            constraint.identifier == "\(identifier)"
        }
        
        view.removeConstraints(viewsConstraints)
    }
    
    func cardLayoutConstraints(card: EstablishmentCard, size: CGFloat, identifier: String) {
        
        card.widthAnchor.dimensionConstraintWithIdentifier(heightOrWidth: self.widthAnchor, multiplier: size, id: identifier).isActive = true
        card.heightAnchor.dimensionConstraintWithIdentifier(heightOrWidth: self.heightAnchor, multiplier: size, id: identifier).isActive = true
        card.centerXAnchor.axisConstraintWithIdentifier(axis: self.centerXAnchor, constant: 0, id: identifier).isActive = true
        card.centerYAnchor.axisConstraintWithIdentifier(axis: self.centerYAnchor, constant: 0, id: identifier).isActive = true
        
        card.cardWidth = self.viewWidth! * size
        print("view width is \(self.frame.width * size)")
        card.cardHeight = self.viewHeight! * size
    }
    
    func dismissView() {
        if self.subviews.count == 0 {
            self.removeFromSuperview()
        }
    }
    
    func resizeNextCard() {
        
        if let nextCard = self.subviews.last as? EstablishmentCard {
            let cardID = "\(self.subviews.count - 1)"
            removeConstraints(view: self, identifier: cardID)
            UIView.animate(withDuration: popCardSpeed, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.cardLayoutConstraints(card: nextCard, size: self.maxCardSize, identifier: cardID)
                nextCard.layoutIfNeeded()
                self.layoutIfNeeded()
            }, completion: nil)
            
            mapViewVC?.mapView.animate(toLocation: nextCard.establishment.coordinate!)
            mapViewVC?.mapView.selectedMarker = nextCard.establishment.mapMarker
            
        }
    }

}
