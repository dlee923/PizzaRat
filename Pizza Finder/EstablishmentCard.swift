//
//  EstablishmentCard.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/4/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

class EstablishmentCard: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCard()
    }
    
    var cardCenter: CGPoint?
    var touchPoint: CGPoint?
    var xDifference: CGFloat?
    var yDifference: CGFloat?
    var cardWidth: CGFloat?
    
    let cardSpeed: Double = 0.25
    let edgeTarget: CGFloat = 0.25
    
    var underLyingCard: EstablishmentCard?
    var establishmentChoicesVC: EstablishmentChoicesVC?
    
    func setUpCard() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cardCenter = self.center
        if let touch = touches.first {
            touchPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            xDifference = touch.location(in: self).x - touchPoint!.x
            yDifference = touch.location(in: self).y - touchPoint!.y
            
            if touch.location(in: self.establishmentChoicesVC?.view).x > ((self.establishmentChoicesVC?.view.frame.width)! * (1-edgeTarget)) {
                self.alpha = ((self.establishmentChoicesVC?.view.frame.width)! * (1-edgeTarget)) / touch.location(in: self.establishmentChoicesVC?.view).x
            } else {
                self.alpha = touch.location(in: self.establishmentChoicesVC?.view).x / ((self.establishmentChoicesVC?.view.frame.width)! * edgeTarget)
            }
        }
        
        self.center = CGPoint(x: self.center.x + xDifference!, y: self.center.y + yDifference!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let lastTouch = touches.first?.location(in: self.superview) else { return }
        
        if lastTouch.x > ((self.establishmentChoicesVC?.view.frame.width)! * (1-edgeTarget)) {
            moveOffScreen(directionIsRight: true)
            
        } else if lastTouch.x < ((self.establishmentChoicesVC?.view.frame.width)! * edgeTarget) {
            moveOffScreen(directionIsRight: false)
        } else {
            UIView.animate(withDuration: cardSpeed, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                self.center = self.cardCenter!
            }, completion: nil)
        }
    }
    
    func moveOffScreen(directionIsRight: Bool) {
        if directionIsRight {
            UIView.animate(withDuration: cardSpeed, animations: {
                self.center = CGPoint(x: self.center.x + ((self.establishmentChoicesVC?.view.frame.width)! * 0.25) + (self.cardWidth! * 0.5), y: self.center.y)
            }, completion: { _ in
                self.popNextCard()
            })
        } else {
            UIView.animate(withDuration: cardSpeed, animations: {
                self.center = CGPoint(x: self.center.x - ((self.establishmentChoicesVC?.view.frame.width)! * 0.25) - (self.cardWidth! * 0.5), y: self.center.y)
            }, completion: { _ in
                self.popNextCard()
            })
        }
    }
    
    func popNextCard() {
        self.removeFromSuperview()
        self.establishmentChoicesVC?.resizeNextCard()
        self.establishmentChoicesVC?.dismissView()
    }
    
    func setCardRotation() {
        // set card rotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
