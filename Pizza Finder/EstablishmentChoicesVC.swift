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
        
        setUpCards(numberOfCards: 3)
    }
    
    var establishments: [EstablishmentsObj]?
    var currentLocation: EstablishmentsObj?
    
    let cardSize: CGFloat = 0.65
    let maxCardSize: CGFloat = 0.75
    var establishmentCards: [EstablishmentCard]?
    var colors: [UIColor] = [.orange, .red, .green, .gray, .yellow]
    
    let popCardSpeed = 0.25
    
    func setUpCards(numberOfCards: Int) {
        for x in 0...numberOfCards {
            let card: EstablishmentCard = {
                let view = EstablishmentCard()
                view.establishmentChoicesVC = self
                view.backgroundColor = colors[x]
                view.cardWidth = self.view.frame.width * cardSize
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            self.view.addSubview(card)
            
            if x == numberOfCards {
                cardLayoutConstraints(card: card, size: maxCardSize, identifier: "\(x)")
            } else {
                cardLayoutConstraints(card: card, size: cardSize, identifier: "\(x)")
            }            
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
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

private let reuseIdentifier = "Cell"

class EstablishmentChoicesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        // Register cell classes
        self.collectionView!.register(EstablishmentChoicesCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    var establishments: [EstablishmentsObj]?
    var currentLocation: EstablishmentsObj?
    let sizeMultiplier: CGFloat = 0.8

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return establishments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.width * sizeMultiplier, height: self.view.frame.height * sizeMultiplier)
        return size
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EstablishmentChoicesCell {
            cell.establishment = establishments?[indexPath.item]
            cell.currentLocation = self.currentLocation
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do something
    }
}

