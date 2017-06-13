//
//  EstablishmentChoicesCollectionViewController.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/1/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import GoogleMaps

class EstablishmentChoicesVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .purple
//        setUpBackButton(buttonSize: backButtonSize, function: #selector(dismissView), view: self.view, target: self)
    }
    
    var establishments: [EstablishmentsObj]? {
        didSet {
            setUpCards(numberOfCards: establishments?.count ?? 0)
        }
    }
    
    var currentLocation: EstablishmentsObj?
    
    let cardSize: CGFloat = 0.65
    let maxCardSize: CGFloat = 0.75
    var establishmentCards: [EstablishmentCard]?
    var colors: [UIColor] = [.orange, .red, .green, .gray, .yellow]
    
    let popCardSpeed = 0.25
    let backButtonSize: CGFloat = 30
    
    func setUpCards(numberOfCards: Int) {
        for x in 0..<numberOfCards {
            let card: EstablishmentCard = {
                let view = EstablishmentCard()
                view.establishmentChoicesVC = self
                view.backgroundColor = colors[x]
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            self.view.addSubview(card)
            
            if x == numberOfCards - 1 {
                cardLayoutConstraints(card: card, size: maxCardSize, identifier: "\(x)")
            } else {
                cardLayoutConstraints(card: card, size: cardSize, identifier: "\(x)")
            }
            
            card.currentLocation = currentLocation
            print("x is \(x)")
            print("number of cards is \(numberOfCards)")
            card.establishment = self.establishments?[x]
        }
    }
    
    func removeConstraints(view: UIView, identifier: String) {
        let viewsConstraints = view.constraints.filter { (constraint) -> Bool in
            constraint.identifier == "\(identifier)"
        }
        
        view.removeConstraints(viewsConstraints)
    }
    
    func cardLayoutConstraints(card: EstablishmentCard, size: CGFloat, identifier: String) {
        
        card.widthAnchor.dimensionConstraintWithIdentifier(heightOrWidth: self.view.widthAnchor, multiplier: size, id: identifier).isActive = true
        card.heightAnchor.dimensionConstraintWithIdentifier(heightOrWidth: self.view.heightAnchor, multiplier: size, id: identifier).isActive = true
        card.centerXAnchor.axisConstraintWithIdentifier(axis: self.view.centerXAnchor, constant: 0, id: identifier).isActive = true
        card.centerYAnchor.axisConstraintWithIdentifier(axis: self.view.centerYAnchor, constant: 0, id: identifier).isActive = true
        
        card.cardWidth = self.view.frame.width * size
        card.cardHeight = self.view.frame.height * size
    }
    
    func dismissView() {
        if self.view.subviews.count == 0 {
            self.dismiss(animated: true, completion: nil)
        }        
    }
    
    func resizeNextCard() {

        if let nextCard = self.view.subviews.last as? EstablishmentCard {
            let cardID = "\(self.view.subviews.count - 1)"
            removeConstraints(view: self.view, identifier: cardID)
            UIView.animate(withDuration: popCardSpeed, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.cardLayoutConstraints(card: nextCard, size: self.maxCardSize, identifier: cardID)
                nextCard.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

